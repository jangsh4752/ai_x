# ✅ 다층 LSTM 시계열 예측 Notebook 예시

import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout

# 데이터 불러오기
file_path = '목적별 국적별 입국(전처리).csv'
df = pd.read_csv(file_path, encoding='cp949', header=1)
df.rename(columns={df.columns[0]: '국적', df.columns[1]: '목적'}, inplace=True)

value_cols = [c for c in df.columns if '년' in c and '월' in c]
long_df = df.melt(id_vars=['국적', '목적'], value_vars=value_cols, var_name='ym', value_name='visitors')

long_df['ym'] = long_df['ym'].str.replace('년', '-').str.replace('월', '')
long_df['year'] = long_df['ym'].str.split('-').str[0].astype(int)
long_df['month'] = long_df['ym'].str.split('-').str[1].astype(int)
long_df['visitors'] = long_df['visitors'].astype(str).str.replace(',', '').astype(float)

country_map = {'중국': 'China', '일본': 'Japan', '미국': 'USA'}
purpose_map = {'관광': 'Tourism', '상용': 'Business', '공용': 'Official', '유학연수': 'Study'}

long_df['country_en'] = long_df['국적'].map(country_map)
long_df['purpose_en'] = long_df['목적'].map(purpose_map)

le_country = LabelEncoder()
le_purpose = LabelEncoder()
long_df['country_code'] = le_country.fit_transform(long_df['country_en'].astype(str))
long_df['purpose_code'] = le_purpose.fit_transform(long_df['purpose_en'].astype(str))

long_df['is_peak'] = long_df['month'].apply(lambda x: 1 if x in [7,8,12] else 0)
long_df = long_df.sort_values(['country_code', 'purpose_code', 'year', 'month'])
long_df['lag_1'] = long_df.groupby(['country_code', 'purpose_code'])['visitors'].shift(1)
long_df['rolling_mean_3'] = long_df.groupby(['country_code', 'purpose_code'])['visitors'].shift(1).rolling(3).mean()

long_df = long_df.dropna().reset_index(drop=True)

features = ['lag_1', 'rolling_mean_3', 'month', 'is_peak']
X = long_df[features].values
y = long_df['visitors'].values

scaler_X = MinMaxScaler()
scaler_y = MinMaxScaler()
X_scaled = scaler_X.fit_transform(X)
y_scaled = scaler_y.fit_transform(y.reshape(-1, 1))

seq_length = 6
X_seq, y_seq = [], []
for i in range(seq_length, len(X_scaled)):
    X_seq.append(X_scaled[i-seq_length:i])
    y_seq.append(y_scaled[i])

X_seq = np.array(X_seq)
y_seq = np.array(y_seq)

model = Sequential()
model.add(LSTM(64, return_sequences=True, input_shape=(X_seq.shape[1], X_seq.shape[2])))
model.add(Dropout(0.2))
model.add(LSTM(32))
model.add(Dropout(0.2))
model.add(Dense(1))

model.compile(optimizer='adam', loss='mse')
model.summary()

model.fit(X_seq, y_seq, epochs=30, batch_size=16)
