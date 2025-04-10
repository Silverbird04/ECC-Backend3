-- 7장. 복수의 테이블 다루기
-- 31강: 집합 연산
-- table sample71_a
CREATE TABLE sample71_a (
    a INTEGER
);
INSERT INTO sample71_a(a) VALUES(1);
INSERT INTO sample71_a(a) VALUES(2);
INSERT INTO sample71_a(a) VALUES(3);
SELECT * FROM sample71_a;

CREATE TABLE sample71_b (
    b INTEGER
);
INSERT INTO sample71_b VALUES(2);
INSERT INTO sample71_b VALUES(10);
INSERT INTO sample71_b VALUES(11);
SELECT * FROM sample71_b;
-- DELETE FROM sample71_b;
--turncate table sample71_b;

-- UNION으로 합집합 구하기
SELECT * FROM sample71_a
UNION
SELECT * FROM sample71_b;

--UNION 사용할 떄의 ORDER BY
SELECT a AS c FROM sample71_a
UNION
SELECT b AS c FROM sample71_b ORDER BY c;

-- 중복 제거 안 함
SELECT * FROM sample71_a
UNION ALL
SELECT * FROM sample71_b;

-- 32강: 테이블 결합
CREATE TABLE sample72_x(
    x CHAR(2)
);
INSERT INTO sample72_x VALUES('A');
INSERT INTO sample72_x VALUES('B');
INSERT INTO sample72_x VALUES('C');
SELECT * FROM sample72_x;

CREATE TABLE sample72_y(
    y INTEGER
);
INSERT INTO sample72_y VALUES(1);
INSERT INTO sample72_y VALUES(2);
INSERT INTO sample72_y VALUES(3);
SELECT * FROM sample72_y;
-- 곱집합
SELECT * FROM sample72_x, sample72_y;

-- 내부결합
-- 상품 item 테이블
CREATE TABLE item(
    item_code CHAR(4) NOT NULL,
    item_name VARCHAR(30),
    maker_name VARCHAR(30),
    price INTEGER,
    item_type VARCHAR(30),
    PRIMARY KEY (item_code)
);
INSERT INTO item VALUES('0001', 'itemA', 'Amaker', 100, 'food');
INSERT INTO item VALUES('0002', 'itemB', 'Amaker', 200, 'food');
INSERT INTO item VALUES('0003', 'itemC', 'Cmaker', 1980, 'daily');
SELECT * FROM item;

--재고수 inventory  테이블
CREATE TABLE inventory(
    item_code CHAR(4),
    in_date DATE,
    in_num INTEGER
);
INSERT INTO inventory VALUES('0001', '2024-01-03', 200);
INSERT INTO inventory VALUES('0002', '2024-02-10', 500);
INSERT INTO inventory VALUES('0003', '2024-02-14', 10);
SELECT * FROM inventory;
-- 필드 제거
ALTER TABLE inventory DROP in_date;

-- 교차결합하기
SELECT * FROM item, inventory;
-- 상품코드가 같은 행을 검색하기(내부결합 결과)
SELECT * FROM item, inventory
WHERE item.item_code = inventory.item_code;
-- 검색할 행과 반환할 열 제한하기
SELECT item.item_name, inventory.in_num FROM item, inventory
WHERE item.item_code = inventory.item_code
AND item.item_type = 'food';

-- 내부결합
SELECT item.item_name, inventory.in_num
FROM item INNER JOIN inventory
ON item.item_code = inventory.item_code
WHERE item.item_type = 'food';

-- 필드 바꿈
UPDATE item
SET maker_name = 'M001'
WHERE item_code = '0001';
UPDATE item
SET maker_name = 'M001'
WHERE item_code = '0002';
UPDATE item
SET maker_name = 'M002'
WHERE item_code = '0003';
ALTER TABLE item CHANGE maker_name maker_code CHAR(4) NOT NULL;
SELECT maker_code FROM item;
-- 메이커 maker 테이블
CREATE TABLE maker (
    maker_code CHAR(4) NOT NULL,
    maker_name VARCHAR(30),
    PRIMARY KEY (maker_code)
);
INSERT INTO maker VALUES('M001', 'Amaker');
INSERT INTO maker VALUES('M002', 'Cmaker');
SELECT * FROM maker;
-- 내부 결합을 이용한 데이터 관리리
SELECT S.item_name, M.maker_name
    FROM item S INNER JOIN maker M
        ON S.maker_code = M.maker_code;

-- 외부결합
INSERT INTO item VALUES('0009', 'extra_item', 'M001', 300, 'food');
SELECT * FROM item;
-- LEFT JOIN
SELECT item.item_name, inventory.in_num
FROM item LEFT JOIN in_num
ON item.item_code = inventory.item_code
WHERE item.item_type = 'food';

-- 33강: 관계형 모델
-- 합집합
SELECT * FROM sample71_a
UNION
SELECT * FROM sample71_b;
-- 차집합
SELECT * FROM sample71_a
EXCEPT
SELECT * FROM sample71_b;
-- 교집합
SELECT * FROM sample71_a
INTERSECT
SELECT * FROM sample71_b;
-- 곱집합
SELECT * FROM sample71_a, sample71_b;
SELECT * FROM sample71_a CROSS JOIN sample71_b;
-- 선택
SELECT * FROM sample71_a WHERE a < 3;
-- 투영
SELECT item_name FROM item;
-- 결합
SELECT *
FROM item INNER JOIN maker
ON item.maker_code = maker.maker_code;

--8장. 데이터베이스 설계
-- 주문 order 테이블
CREATE TABLE ord (
    ord_num INTEGER NOT NULL,
    ord_date VARCHAR(6),
    consumer_num INTEGER
);
INSERT INTO ord VALUES(1, '1/1', 1);
INSERT INTO ord VALUES(2, '2/1', 2);
INSERT INTO ord VALUES(3, '2/5', 1);
SELECT * FROM ord;

-- 주문상품 item 테이블
CREATE TABLE product (
    ord_num INTEGER NOT NULL,
    item_code CHAR(4),
    num INTEGER
);
INSERT INTO product VALUES(1, '0001', 1);
INSERT INTO product VALUES(1, '0002', 10);
INSERT INTO product VALUES(2, '0001', 2);
INSERT INTO product VALUES(2, '0002', 3);
INSERT INTO product VALUES(3, '0001', 3);
INSERT INTO product VALUES(3, '0003', 1);
SELECT * FROM product;

--트랜잭션 내에서의 발주처리
START TRANSACTION;
INSERT INTO ord VALUES(4, '3/1', 1);
INSERT INTO product VALUES(4, '0003', 1);
INSERT INTO product VALUES(4, '0004', 2);
COMMIT;
SELECT * FROM product WHERE ord_num = 4;
-- ROLLBACK 사용
START TRANSACTION;
INSERT INTO ord VALUES(4, '3/1', 1);
INSERT INTO product VALUES(4, '0003', 1);
INSERT INTO product VALUES(4, '0004', 2);
ROLLBACK;
COMMIT;
SELECT * FROM product WHERE ord_num = 4;

