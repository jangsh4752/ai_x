-- [ III ] join : 2개 이상의 테이블을 연결하여 데이터를 검색하는 방법
SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 1행(직원정보)
SELECT * FROM DEPT; -- 4행(부서정보)
-- CROSS JOIN
SELECT * 
    FROM EMP, DEPT
    WHERE ENAME='SCOTT'; -- 1(EMP갯수) * 4(DEPT갯수) => 4행

-- ★ 1. EQUI JOIN(공통필드 값이 일치되는 조건만 JOIN)
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPT.DEPTNO, DNAME, LOC
    FROM EMP, DEPT
    WHERE ENAME='SCOTT' AND EMP.DEPTNO = DEPT.DEPTNO;

SELECT EMPNO NO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, D.DEPTNO, DNAME, LOC -- (3)
    FROM EMP E, DEPT D                              -- (1)    
    WHERE ENAME='SCOTT' AND E.DEPTNO = D.DEPTNO     -- (2) 테이블 별칭만 사용 가능    
    ORDER BY NO;                                    -- (4)        
    
    -- ex1) 모든 사원의 사번, 이름, JOB, 상사사번, 부서번호, 부서명, 근무지 출력
    SELECT EMPNO, ENAME, JOB, MGR, D.DEPTNO, DNAME, LOC
        FROM EMP E, DEPT D
            WHERE E.DEPTNO = D.DEPTNO;
    -- ex2) 급여(SAL)가 2000이상인 직원의 이름, JOB, 급여, 부서명, 근무지 출력
    SELECT ENAME, JOB, SAL, DNAME, LOC
        FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO AND SAL>=2000;
    -- ex3) 근무지(LOC)가 'CHICAGO인 직원의 이름, JOB, 급여, 부서번호 출력
    SELECT ENAME, JOB, SAL, E.DEPTNO FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND LOC='CHICAGO';
    -- ex4) 82년도에 입사한 10, 20번 부서직원의 이름, 급여, 근무지(급여순) 출력
    SELECT ENAME, SAL, LOC FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO 
        AND (TO_CHAR(HIREDATE,'RR/MM/DD') LIKE '82/%') 
        AND E.DEPTNO IN (10, 20)
            ORDER BY SAL;
    -- ex5) JOB이 'SALESMAN'이거나 'MANAGER'인 사원의 이름, 급여, 상여금, 연봉((SAL+COMM)*12), 부서명, 근무지 출력
        -- 연봉이 큰 순
    SELECT ENAME, SAL, NVL(COMM, 0), (SAL+NVL(COMM, 0))*12 연봉, DNAME, LOC
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND JOB IN ('SALESMAN', 'MANAGER')
            ORDER BY 연봉 DESC;
    -- ex6) COMM이 NULL이고, SAL이 2000대인 사원의 이름, 급여, 입사일, 부서번호, 부서명 출력
        -- 부서명 순, 급여순 정렬
    SELECT ENAME, SAL, HIREDATE, E.DEPTNO, DNAME
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO 
                AND COMM IS NULL
                AND SAL BETWEEN 2000 AND 2999
                ORDER BY DNAME, SAL;    
    -- 탄탄1	뉴욕에서 근무하는 사원의 이름과 급여를 출력하시오
    SELECT * FROM DEPT;
    SELECT ENAME, SAL 
        FROM EMP E, DEPT D 
        WHERE E.DEPTNO=D.DEPTNO AND LOC='NEW YORK';
    -- 탄탄2 ACCOUNTING 부서 소속 사원의 이름과 입사일을 출력하시오
    SELECT ENAME, HIREDATE 
        FROM EMP E, DEPT D 
        WHERE E.DEPTNO=D.DEPTNO AND DNAME='ACCOUNTING';
    -- 탄탄3 직급이 MANAGER인 사원의 이름, 부서명을 출력하시오
    SELECT ENAME, DNAME
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND JOB='MANAGER';
    -- 탄탄4 Comm이 null이 아닌 사원의 이름, 급여, 부서코드, 근무지를 출력하시오.
    SELECT ENAME, SAL, E.DEPTNO, LOC
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;

-- ★ 2. NON-EQUI JOIN
SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 직원정보
SELECT * FROM SALGRADE; -- 급여등급 정보
SELECT * FROM EMP, SALGRADE
    WHERE ENAME='SCOTT' AND SAL BETWEEN LOSAL AND HISAL;
    -- ex) 모든 사원의 사번, 이름, JOB, 상사사번, 급여, 급여등급(1등급, 2등급, ...)출력
    SELECT EMPNO, ENAME, JOB, MGR, SAL, GRADE||'등급' GRADE
        FROM EMP, SALGRADE
            WHERE SAL BETWEEN LOSAL AND HISAL;
    -- ex) 모든 사원의 사번, 이름, JOB, 상사사번, 급여, 급여등급(1등급, 2등급, ...)출력
    SELECT EMPNO, ENAME, JOB, MGR, SAL, GRADE||'등급' GRADE
        FROM EMP E, SALGRADE, DEPT D
            WHERE SAL BETWEEN LOSAL AND HISAL AND E.DEPTNO = D.DEPTNO;        
    
    -- 탄탄1. comm이 null이 아닌 사원의 이름, 급여, 등급, 부서번호, 부서이름, 근무지를 출력하시오.
    SELECT ENAME, SAL, GRADE, E.DEPTNO, D.DNAME, LOC
        FROM EMP E, DEPT D, SALGRADE
            WHERE COMM IS NOT NULL AND SAL BETWEEN LOSAL AND HISAL;
    -- 탄탄2. 이름, 급여, 입사일, 급여등급
    SELECT ENAME, SAL, HIREDATE, GRADE
        FROM EMP, SALGRADE;
    -- 탄탄3. 이름, 급여, 급여등급, 연봉, 부서명을 부서명순으로 정렬하여 출력. 부서가 같으면 연봉순. 연봉=(sal+comm)*12 comm이 null이면 0
    SELECT ENAME, SAL, GRADE, (SAL+NVL(COMM, 0)) 연봉, DNAME
        FROM EMP, SALGRADE, DEPT
            ORDER BY DNAME, 연봉;
    -- 탄탄4. 이름, 업무, 급여, 등급, 부서코드, 부서명 출력. 급여가 1000~3000사이. 정렬조건 : 부서별, 부서같으면 업무별, 업무같으면 급여 큰순
    SELECT ENAME, JOB, SAL, GRADE, E.DEPTNO, DNAME
        FROM EMP E, DEPT D, SALGRADE
            WHERE E.DEPTNO=D.DEPTNO
            AND SAL BETWEEN 1000 AND 3000
            ORDER BY E.DEPTNO, JOB, SAL DESC;
    -- 탄탄5. 이름, 급여, 등급, 입사일, 근무지. 81년에 입사한 사람. 등급 큰순
    SELECT ENAME, SAL, GRADE, HIREDATE, LOC
        FROM EMP, SALGRADE, DEPT
            WHERE TO_CHAR(HIREDATE,'RR/MM/DD') LIKE '81%'
            ORDER BY GRADE DESC;

-- ★ 3. SELF JOIN ★ -- 
-----------------------
SELECT * FROM EMP WHERE ENAME='SMITH';
SELECT EMPNO, ENAME FROM EMP WHERE EMPNO=7902;
SELECT WORKER.EMPNO, WORKER.ENAME, WORKER.MGR, MANAGER.EMPNO, MANAGER.ENAME
    FROM EMP WORKER, EMP MANAGER
        WHERE WORKER.ENAME='SMITH' AND WORKER.MGR=MANAGER.EMPNO;

SELECT WORKER.EMPNO, WORKER.ENAME, WORKER.MGR, MANAGER.EMPNO, MANAGER.ENAME
    FROM EMP WORKER, EMP MANAGER
        WHERE WORKER.ENAME='SMITH' AND WORKER.MGR=MANAGER.EMPNO;
    -- ex) 모든 사원의 사번, 이름, 상사의 사번, 상사이름
    SELECT W.EMPNO, W.ENAME, W.MGR, M.ENAME MNG
        FROM EMP W, EMP M
            WHERE W.MGR=M.EMPNO;
    -- ex) 'SMITH의 상사는 JONES이다' 포맷으로 출력
    SELECT W.ENAME || '의 상사는 ' || M.ENAME || '이다' MESSAGE
        FROM EMP W, EMP M
            WHERE W.MGR=M.EMPNO(+);
    -- 탄탄1. 매니저가 KING인 사원들의 이름과 직급을 출력하시오.
    SELECT W.ENAME, W.JOB --, W.MGR, M.ENAME
        FROM EMP W, EMP M
            WHERE W.MGR=M.EMPNO AND M.ENAME='KING';
    SELECT EMPNO FROM EMP WHERE ENAME='KING';
    SELECT ENAME, JOB FROM EMP
        WHERE MGR=(SELECT EMPNO FROM EMP WHERE ENAME='KING'); -- 서브쿼리
    -- 탄탄2. SCOTT과 동일한 부서번호에서 근무하는 사원의 이름을 출력하시오
    SELECT W2.ENAME, W2.DEPTNO FROM EMP W1, EMP W2
        WHERE W1.DEPTNO=W2.DEPTNO
        AND W1.ENAME='SCOTT'
        AND W2.ENAME != 'SCOTT';
    SELECT ENAME FROM EMP
        WHERE DEPTNO=(SELECT DEPTNO FROM EMP WHERE ENAME='SCOTT')
        AND ENAME != 'SCOTT'; -- SUBQUERY 이용

-----------------------------
-- ★ 4. OUTER JOIN ★ -- self join, equi join시 조건이 만족하지 않는 행까지 나타내는 join
-----------------------------
-- 배제된 행을 결과에 포함시킬 경우 + 기호를 정보가 부족한 컬럼 이름뒤에 덧붙임
-- (1) self join에서의 OUTER JOIN
SELECT W.EMPNO, W.ENAME, W.MGR, M.EMPNO, M.ENAME
    FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO(+);
    -- ex) 모든 사원에 대해 'SMITH의 상사는 FORD다'....'KING의 상사는 없다'
    SELECT W.ENAME || '의 상사는 '|| NVL(M.ENAME, '없') || '다.' MESSAGE
        FROM EMP W, EMP M
            WHERE W.MGR=M.EMPNO(+);
    -- 말단 직원
    SELECT M.ENAME
        FROM EMP W, EMP M
            WHERE W.MGR(+) = M.EMPNO AND W.ENAME IS NULL;
-- (2) EQUI JOIN에서의 OUTER JOIN
SELECT * FROM DEPT; -- 10, 20, 30, 40
SELECT * FROM EMP; -- 10, 20, 30
SELECT ENAME, E.DEPTNO, DNAME
    FROM EMP E, DEPT D
        WHERE E.DEPTNO(+)=D.DEPTNO;


    
-- ★ <셤 연습문제>
-- Part1
--1. 모든 사원에 대한 이름, 부서번호, 부서명을 출력하는 SELECT 문장을 작성하여라.
    SELECT ENAME, DEPT.DEPTNO, DNAME FROM EMP, DEPT;
--2. NEW YORK에서 근무하고 있는 사원에 대하여 이름, 업무, 급여, 부서명을 출력
    SELECT ENAME, JOB, SAL, DNAME
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND LOC='NEW YORK';
--3. 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력
    SELECT ENAME, DNAME, LOC
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;
--4. 이름 중 L자가 있는 사원에 대하여 이름,업무,부서명,위치를 출력
    SELECT ENAME, JOB, DNAME, LOC
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND ENAME LIKE '%L%';
--5. 사번, 사원명, 부서코드, 부서명을 검색하라(단, 사원명기준으로 오름차순 정렬)
    SELECT EMPNO, ENAME, D.DEPTNO, DNAME
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO
                ORDER BY ENAME;
--6. 사번, 사원명, 급여, 부서명을 검색하라. 
    --단 급여가 2000이상인 사원에 대하여 급여를 기준으로 내림차순으로 정렬하시오
    SELECT EMPNO, ENAME, SAL, DNAME
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO
            AND SAL>=2000
                ORDER BY SAL DESC;
--7. 사번, 사원명, 업무, 급여, 부서명을 검색하시오. 단 업무가 MANAGER이며 급여가 2500이상인
-- 사원에 대하여 사번을 기준으로 오름차순으로 정렬하시오.
    SELECT EMPNO, ENAME, JOB, SAL, DNAME
        FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO
            AND JOB='MANAGER' AND SAL>=2500
                ORDER BY EMPNO;
--8. 사번, 사원명, 업무, 급여, 등급을 검색하시오(단, 급여기준 내림차순으로 정렬)
    SELECT EMPNO, ENAME, JOB, SAL, GRADE
        FROM EMP E, DEPT D, SALGRADE
            WHERE E.DEPTNO=D.DEPTNO
                ORDER BY SAL DESC;
-- Part2
--1. 이름, 직속상사명
SELECT WORKER.ENAME 이름, MANAGER.ENAME 직속상사명
    FROM EMP WORKER, EMP MANAGER
        WHERE WORKER.MGR=MANAGER.EMPNO;
--2. 이름, 급여, 업무, 직속상사명
SELECT W.ENAME 이름, W.SAL, W.JOB, M.ENAME 직속상사명
    FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO;
--3. 이름, 급여, 업무, 직속상사명 . (상사가 없는 직원까지 전체 직원 다 출력.
    --상사가 없을 시 '없음'으로 출력)
SELECT W.ENAME, W.SAL, W.JOB, NVL(M.ENAME,'없음') 직속상사명
    FROM EMP W, EMP M
        WHERE W.MGR=M.EMPNO(+);
--4. 이름, 급여, 부서명, 직속상사명
SELECT W.ENAME, W.SAL, D.DNAME, NVL(M.ENAME,'없음')
    FROM EMP W, EMP M, DEPT D
        WHERE W.DEPTNO=D.DEPTNO AND W.MGR=M.EMPNO(+);
--5. 상사가 없는 직원과 상사가 있는 직원 모두에 대해 이름, 급여, 부서코드, 부서명, 근무지, 직속상사명을 출력하시오(단, 직속상사가 없을 경우 직속상사명에는 ‘없음’으로 대신 출력하시오)
SELECT DISTINCT W.ENAME, W.SAL, W.DEPTNO, DNAME, LOC, NVL(M.ENAME,'없음')
    FROM EMP W, EMP M, DEPT D
        WHERE W.DEPTNO=D.DEPTNO
        AND W.ENAME != M.ENAME
        AND W.MGR = M.EMPNO;
--6. 이름, 급여, 등급, 부서명, 직속상사명. 급여가 2000이상인 사람
SELECT W.ENAME, W.SAL, GRADE, DNAME, M.ENAME
    FROM EMP W, EMP M, DEPT D, SALGRADE
        WHERE W.DEPTNO = D.DEPTNO
        AND W.SAL>=2000
        AND W.MGR = M.EMPNO;
--7. 이름, 급여, 등급, 부서명, 직속상사명, (직속상사가 없는 직원까지 전체직원 부서명 순 정렬)
SELECT W.ENAME, W.SAL, GRADE, DNAME, M.ENAME
    FROM EMP W, EMP M, DEPT D, SALGRADE
        WHERE W.DEPTNO = D.DEPTNO
        AND W.MGR = M.EMPNO(+)
        ORDER BY DNAME;
--8. 이름, 급여, 등급, 부서명, 연봉, 직속상사명. 연봉=(급여+comm)*12으로 계산
SELECT W.ENAME, W.SAL, S.GRADE, DNAME, ((W.SAL+NVL(W.COMM, 0))*12) 연봉, M.ENAME
    FROM EMP W, EMP M, DEPT D, SALGRADE S
        WHERE W.DEPTNO = D.DEPTNO
        AND W.MGR = M.EMPNO;
--9. 8번을 부서명 순 부서가 같으면 급여가 큰 순 정렬
SELECT W.ENAME, W.SAL, S.GRADE, DNAME, ((W.SAL+NVL(W.COMM, 0))*12) 연봉, M.ENAME
    FROM EMP W, EMP M, DEPT D, SALGRADE S
        WHERE W.DEPTNO = D.DEPTNO
        AND W.MGR = M.EMPNO
            ORDER BY DNAME, W.SAL DESC;
--10. 사원테이블에서 사원명, 사원의 상사를 검색하시오(상사가 없는 직원까지 전체).
SELECT W.ENAME, NVL(M.ENAME,'없음') 상사
    FROM EMP W, EMP M
        WHERE W.MGR = M.EMPNO(+);
--11. 사원명, 상사명, 상사의 상사명을 검색하시오(self join)
SELECT W.ENAME, NVL(M.ENAME,'없음'), NVL(NVL(MM.ENAME,'없음'), '없음')
    FROM EMP W, EMP M, EMP MM
        WHERE W.MGR = M.EMPNO
        AND M.MGR = MM.EMPNO;
--12. 위의 결과에서 상위 상사가 없는 모든 직원의 이름도 출력되도록 수정하시오(outer join)
SELECT W.ENAME, NVL(M.ENAME,'없음'), NVL(NVL(MM.ENAME,'없음'), '없음')
    FROM EMP W, EMP M, EMP MM
        WHERE W.MGR = M.EMPNO(+)
        AND M.MGR = MM.EMPNO(+);    
    
    
    
    
    
    
    
    