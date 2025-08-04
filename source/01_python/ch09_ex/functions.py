# function.py => fn1_() ~ fn9_()
from customer import Customer
import re
# 1. 입력
def fn1_insert_customer_info():
    '''
    사용자로부터 name, phone, email, age, grade, etc를 입력받아 Customer형 객체 반환
    '''
    name = input("이름을 입력하세요 :")
    name_pattern = r'[가-힣]{2,}'
    while not re.search(name_pattern, name):
        print('이름을 제대로 입력하세요(한글 2글자 이상) :')
        name = input("이름을 입력하세요 :")
    phone = input("전화번호를 입력하세요(000-0000-0000 양식) :")
    email = input("이메일을 입력하세요 :")
    while True:
        try:
            age = int(input("나이를 입력하세요 :"))
            if age<0 or age>130 :
                raise Exception('나이 범위 이상')
            break
        except:
            print("올바른 나이를 입력하세요")
    try :
        grade = int(input("등급을 입력하세요(1~5) :"))
        if grade<1 :
            grade = 1
        if grade >5 :
            grade = 5
    except:
        print('유효하지 않은 등급 입력시 1등급으로 초기화')
        grade = 1
    etc = input("기타 정보를 입력하세요 :")
    return Customer(name, phone, email, age, grade, etc)

# 2.전체 출력
def fn2_print_customers(customer_list):
    'customer_list를 출력(pdf 40page에 보여진 형식으로)'
    print('='*65)
    print('{:^55}'.format('고객 정보'))
    print('-'*65)
    print("{:>5}\t{:3}\t{:13}\t{:10}\t{:3}\t{}".format("GRADE", "이름", "전화",
                                                       "메일", "나이", "기타"))
    print('='*65)
    for customer in customer_list:
        print(customer)

# 3.삭제 (동명이인이 있을 경우 구현 해당 동명이인을 지울지 묻고 지우기)
def fn3_delete_customer(customer_list):
    name = input('삭제할 이름을 입력하세요: ').strip()
    matched = [customer for customer in customer_list if customer.name == name]

    if not matched:
        print("일치하는 이름이 없습니다.")
        return

    if len(matched) == 1:
        customer_list.remove(matched[0])
        print(f"{matched[0].name} 고객 정보를 삭제했습니다.")
        return

    print("동명이인이 있습니다. 삭제할 고객을 선택하세요:")
    for idx, customer in enumerate(matched, start=1):
        print(f"{idx}. {customer}")

    try:
        sel = int(input("삭제할 고객 번호를 입력하세요: "))
        if 1 <= sel <= len(matched):
            to_delete = matched[sel - 1]
            customer_list.remove(to_delete)
            print(f"{to_delete.name} 고객 정보를 삭제했습니다.")
        else:
            print("잘못된 번호입니다.")
    except ValueError:
        print("숫자를 입력해야 합니다.")

# 4.이름찾기
def fn4_search_customer(customer_list):
    '''
    찾고자 하는 이름을 input으로 입력받아, customer_list에서 검색하여 
    같은 이름이 있으면 search_list에 append한 후 search_list 출력
    일치하는 이름이 없으면 없다고 출력
    '''
    search_name = input("조회하실 이름을 입력하세요 :")
    search_list = []
    for customer in customer_list:
        if customer.name == search_name:
            search_list.append(customer)
    if search_list:
        fn2_print_customers(search_list)
    else :
        print('일치하는 정보가 없습니다.')

# 5.내보내기
def fn5_save_customer_csv(customer_list):
    '매개변수로 받은 customer_list를 딕셔너리 리스트로 변환해서 csv 출력'
    import csv
    if customer_list:
        customer_dic_list = []
        for customer in customer_list:
            customer_dic_list.append(customer.as_dic())
        fieldnames = list(customer_dic_list[0].keys())
        filename = input('저장할 csv 파일명은?')
        with open("data/{}.csv".format(filename), "w", encoding="utf-8", newline="") as f:
            dict_writer = csv.DictWriter(f, fieldnames=fieldnames)
            dict_writer.writeheader() # 헤더
            dict_writer.writerows(customer_dic_list)
            print(f"data/{filename}.csv 내보내기 완료")
    else :
        print("입력된 회원 데이터가 없어 csv 내보내기 불가합니다.")        

# 9. 종료 (종료하기 전 customer_list를 txt파일에 저장하고 종료)
def fn9_save_customer_txt(customer_list):
    '''
    매개변수로 받은 customer_list를 ["","",...]형식으로 바꿔
    ch09_customers.txt 로 백업
    '''
    customer_txt_list = []
    for customer in customer_list:
        customer_txt_list.append(customer.to_list_style() + '\n')
    with open("data/ch09_customers.txt", "w", encoding="utf-8") as f:
        f.writelines(customer_txt_list)        