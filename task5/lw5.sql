--1. Добавить внешние ключи

ALTER TABLE dealer 
ADD FOREIGN KEY (id_company) REFERENCES company(id_company);

ALTER TABLE production
ADD FOREIGN KEY (id_company) REFERENCES company(id_company);

ALTER TABLE production 
ADD FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine);

ALTER TABLE [order] 
ADD FOREIGN KEY (id_production) REFERENCES production(id_production);

ALTER TABLE [order]
ADD FOREIGN KEY (id_dealer) REFERENCES dealer(id_dealer);

ALTER TABLE [order]
ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy);

--2 Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.
SELECT pharmacy.name, [order].date, [order].quantity
FROM [order]
INNER JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
INNER JOIN production ON [order].id_production = production.id_production
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордерон' and company.name = 'Аргус';

--3 Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

SELECT medicine.name
FROM medicine
INNER JOIN production ON medicine.id_medicine = production.id_medicine
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN [order] ON production.id_production = [order].id_production
WHERE company.name = 'Фарма' and production.id_production NOT IN (
	SELECT [order].id_production 
	FROM [order]
	WHERE [order].date < '2019-01-25')
GROUP BY medicine.name;

--4 Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов

SELECT MIN(production.rating), MAX(production.rating), company.name
FROM production
INNER JOIN medicine ON production.id_medicine = medicine.id_medicine
INNER JOIN company ON production.id_company = company.id_company
INNER JOIN [order] ON production.id_production = [order].id_production
GROUP BY company.name
HAVING count(production.id_production) >= 120

--5 Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT pharmacy.name, dealer.name
FROM dealer
INNER JOIN company ON dealer.id_company = company.id_company
LEFT JOIN [order] ON dealer.id_dealer = [order].id_dealer
LEFT JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
WHERE company.name = 'AstraZeneca'
ORDER BY pharmacy.name;

-- 6 Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
BEGIN TRANSACTION

UPDATE production
SET production.price = production.price * 0.8
WHERE production.id_production IN 
(
	SELECT production.id_production
	FROM production
	INNER JOIN medicine ON production.id_medicine = medicine.id_medicine
	WHERE production.price > 3000 and medicine.cure_duration <= 7
);

SELECT *
FROM production
INNER JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE production.price > 3000 and medicine.cure_duration <= 7

ROLLBACK

--7 Добавить необходимые индексы

CREATE NONCLUSTERED INDEX[IX_medicine_name] ON medicine
(
	name ASC
);

CREATE NONCLUSTERED INDEX[IX_pharmacy_name] ON pharmacy
(
	name ASC
);

CREATE NONCLUSTERED INDEX[IX_company_name] ON company
(
	name ASC
);

CREATE NONCLUSTERED INDEX[IX_dealer_name] ON dealer 
(
	name ASC
);

CREATE NONCLUSTERED INDEX[IX_dealer_id_company] ON dealer
(
	id_company ASC
);

CREATE NONCLUSTERED INDEX[IX_production_id_company] ON production
(
	id_company ASC
);

CREATE NONCLUSTERED INDEX[IX_production_id_medicine] ON production
(
	id_medicine ASC
);

CREATE NONCLUSTERED INDEX[IX_order_id_production] ON [order]
(
	id_production ASC
);

CREATE NONCLUSTERED INDEX[IX_order_id_dealer] ON [order] 
(
	id_dealer ASC
);

CREATE NONCLUSTERED INDEX[IX_order_id_pharmacy] ON [order] 
(
	id_pharmacy ASC
);