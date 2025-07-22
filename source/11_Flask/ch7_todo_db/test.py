# pip install flask
todo_data = {
    1 : {
        'id' : 1,
        'title' : 'flask 공부',
        'is_done' : False,
    },
    2 : {
        'id' : 2,
        'title' : 'django 공부',
        'is_done' : False,
    },
}
ret = list(todo_data.values()) # 딕셔너리 리스트로
print('첫 실행시 할 일들 : ', ret)
next_id = max(todo_data.keys()) + 1 if len(todo_data) > 0 else 1
print('다음 추가 시 id', next_id)
todo_data[next_id] = {
    'id' : next_id,
    'title' : '다음 추가 할 일',
    'is_done' : False,
}
ret = list(todo_data.values())
for todo in ret:
    print(todo['id'], todo['title'], todo['is_done'])
    print(todo)