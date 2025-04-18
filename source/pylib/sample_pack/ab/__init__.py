'''
sample_pack/ab/__init__.py
from sample_pack.ab import * 수행할 경우 
    자동 import될 모듈 지정 가능(__all__)

sample_pack/ab/a.py
sample_pack/ab/b.py
'''
__all__ = ['a']
print('sample_pack패키지 안의 ab패키지가 로드됩니다.')