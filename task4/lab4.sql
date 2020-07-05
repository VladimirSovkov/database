--1.Добавить внешние ключи
ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client (id_client);

ALTER TABLE room_in_booking 
ADD FOREIGN KEY (id_booking) REFERENCES booking (id_booking);


ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room (id_room);

ALTER TABLE room
ADD FOREIGN KEY (id_hotel) REFERENCES hotel (id_hotel);

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category (id_room_category);

--2 Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г

SELECT client.id_client, client.name, client.phone FROM client
INNER JOIN booking ON client.id_client = booking.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE 
	hotel.name = 'Космос' and
	room_category.name = 'Люкс' and
	room_in_booking.checkin_date <= '01.04.2019' and
	room_in_booking.checkout_date > '01.04.2019';

--3. Дать список свободных номеров всех гостиниц на 22 апреля

SELECT room.id_room, room.id_hotel, room.id_room_category, room.number, room.price FROM room
WHERE id_room NOT IN (
	SELECT room_in_booking.id_room FROM room_in_booking
	WHERE room_in_booking.checkin_date <= '22.04.2019' and room_in_booking.checkout_date > '22.04.2019')
ORDER BY room.id_room;

--4 Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров

SELECT COUNT(client.id_client) AS Counts, room_category.name FROM room_category
INNER JOIN room ON room.id_room_category = room_category.id_room_category
INNER JOIN room_in_booking ON room_in_booking.id_room = room.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN client ON client.id_client = booking.id_client
WHERE 
	hotel.name = 'Космос' and
	room_in_booking.checkin_date <= '23.03.2019' and 
	room_in_booking.checkout_date > '23.03.2019'
GROUP BY room_category.name

--5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда
--гость, номер и дата 

SELECT client.name, room_in_booking.id_room, room_in_booking.checkout_date
FROM client
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room_in_booking.id_room = room.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN (  SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS last_data
			FROM room_in_booking
			WHERE 
				room_in_booking.checkout_date >= '01.04.2019' AND
				room_in_booking.checkout_date < '01.05.2019'
				GROUP BY room_in_booking.id_room) AS date_of_last_stay_in_room
ON date_of_last_stay_in_room.id_room = room_in_booking.id_room
WHERE date_of_last_stay_in_room.last_data = room_in_booking.checkout_date AND hotel.name = 'Космос' 
GROUP BY client.name, room_in_booking.id_room, room_in_booking.checkout_date
ORDER BY client.name


--6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая

UPDATE room_in_booking
SET room_in_booking.checkout_date = DATEADD(day, 2, checkout_date)
FROM room_in_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
WHERE 
	hotel.name = 'Космос' and
	room_category.name = 'Бизнес' and
	room_in_booking.checkin_date = '10.05.2019';

--7 Найти все "пересекающиеся" варианты проживания  
SELECT * 
FROM room_in_booking room_in_booking1, room_in_booking room_in_booking2
WHERE 
	room_in_booking1.id_room = room_in_booking2.id_room and
	room_in_booking1.id_room_in_booking != room_in_booking2.id_room_in_booking and
	((room_in_booking2.checkin_date <= room_in_booking1.checkin_date and room_in_booking2.checkout_date > room_in_booking1.checkin_date))
ORDER BY room_in_booking1.id_room_in_booking;

--8 Создать бронирование в транзакции
BEGIN TRANSACTION
	INSERT INTO booking VALUES(1, '01.04.2020');
	INSERT INTO room_in_booking VALUES(SCOPE_IDENTITY(), 1, '22.04.2020', '30.04.2020');
ROLLBACK;

--9. Добавить необходимые индексы для всех таблиц

-- booking
CREATE NONCLUSTERED INDEX[IX_booling_id_client_booking_date] ON booking
(
	id_client ASC,
	booking_date ASC
)

CREATE NONCLUSTERED INDEX[IX_booling_booking_date] ON booking
(
	booking_date ASC
)

--room_in_booking
CREATE NONCLUSTERED INDEX[IX_room_in_booking_checkin_date_checkout_date] ON room_in_booking
(
	checkin_date ASC,
	checkout_date ASC
)

CREATE NONCLUSTERED INDEX[IX_room_in_booking_id_booking] ON room_in_booking
(
	id_booking ASC
)

CREATE NONCLUSTERED INDEX[IX_room_in_booking_id_room] ON room_in_booking
(
	id_room ASC
)

--room
CREATE NONCLUSTERED INDEX[IX_room_id_hotel_id_room_category] ON room
(
	id_hotel ASC,
	id_room_category ASC
)

CREATE NONCLUSTERED INDEX[IX_room_id_hotel] ON room
(
	id_hotel ASC
)

CREATE NONCLUSTERED INDEX[IX_room_id_room_category] ON room
(
	id_room_category ASC
)

--hotel
CREATE UNIQUE NONCLUSTERED INDEX[IX_hotel_name] ON hotel
(
	name ASC
)

--room_category
CREATE NONCLUSTERED INDEX[IX_category_name] ON room_category
(
	name ASC
)