--1.�������� ������� �����
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

--2 ������ ���������� � �������� ��������� �������, ����������� � ������� ��������� ����� �� 1 ������ 2019�

SELECT client.id_client, client.name, client.phone FROM client
INNER JOIN booking ON client.id_client = booking.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE 
	hotel.name = '������' and
	room_category.name = '����' and
	room_in_booking.checkin_date <= '01.04.2019' and
	room_in_booking.checkout_date > '01.04.2019';

--3. ���� ������ ��������� ������� ���� �������� �� 22 ������

SELECT room.id_room, room.id_hotel, room.id_room_category, room.number, room.price FROM room
WHERE id_room NOT IN (
	SELECT room_in_booking.id_room FROM room_in_booking
	WHERE room_in_booking.checkin_date <= '22.04.2019' and room_in_booking.checkout_date > '22.04.2019')
ORDER BY room.id_room;

--4 ���� ���������� ����������� � ��������� ������� �� 23 ����� �� ������ ��������� �������

SELECT COUNT(client.id_client) AS Counts, room_category.name FROM room_category
INNER JOIN room ON room.id_room_category = room_category.id_room_category
INNER JOIN room_in_booking ON room_in_booking.id_room = room.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN booking ON booking.id_booking = room_in_booking.id_booking
INNER JOIN client ON client.id_client = booking.id_client
WHERE 
	hotel.name = '������' and
	room_in_booking.checkin_date <= '23.03.2019' and 
	room_in_booking.checkout_date > '23.03.2019'
GROUP BY room_category.name

--5. ���� ������ ��������� ����������� �������� �� ���� �������� ��������� �������, ��������� � ������ � ��������� ���� ������

SELECT client.id_client, client.name, room_in_booking.checkout_date FROM client
INNER JOIN booking ON booking.id_client = client.id_client
INNER JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
INNER JOIN room ON room_in_booking.id_room = room.id_room
INNER JOIN (SELECT hotel.id_hotel, hotel.name FROM hotel
	WHERE hotel.name = '������') AS Hotel ON Hotel.id_hotel = room.id_hotel
WHERE 
	room_in_booking.checkout_date >= '01.04.2019' and 
	room_in_booking.checkout_date < '01.05.2019'
GROUP BY room_in_booking.checkout_date, client.id_client, client.name

--6. �������� �� 2 ��� ���� ���������� � ��������� ������� ���� �������� ������ ��������� �������, ������� ���������� 10 ���

UPDATE room_in_booking
SET room_in_booking.checkout_date = DATEADD(day, 2, checkout_date)
FROM room_in_booking
INNER JOIN room ON room.id_room = room_in_booking.id_room
INNER JOIN hotel ON hotel.id_hotel = room.id_hotel
INNER JOIN room_category ON room_category.id_room_category = room.id_room_category
WHERE 
	hotel.name = '������' and
	room_category.name = '������' and
	room_in_booking.checkin_date = '10.05.2019';

--7 ����� ��� "��������������" �������� ����������  
SELECT * 
FROM room_in_booking room_in_booking1, room_in_booking room_in_booking2
WHERE 
	room_in_booking1.id_room = room_in_booking2.id_room and
	room_in_booking1.id_room_in_booking != room_in_booking2.id_room_in_booking and
	((room_in_booking2.checkin_date <= room_in_booking1.checkin_date and room_in_booking2.checkout_date > room_in_booking1.checkin_date))
ORDER BY room_in_booking1.id_room_in_booking;

--8 ������� ������������ � ����������

BEGIN TRANSACTION
	INSERT INTO booking VALUES(1, '01.04.2020');
COMMIT;

--9. �������� ����������� ������� ��� ���� ������

--client

CREATE UNIQUE NONCLUSTERED INDEX[IX_client_phone] ON client
(
	phone ASC
)

CREATE NONCLUSTERED INDEX[IX_client_name] ON client
(
	name ASC
)

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

CREATE NONCLUSTERED INDEX[IX_hotel_stars] ON hotel
(
	stars ASC
)

--room_category
CREATE NONCLUSTERED INDEX[IX_category_name] ON room_category
(
	name ASC
)

