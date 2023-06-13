-- find description about the incident
SELECT description
FROM crime_scene_reports
WHERE year = 2021
AND day = 28
AND month = 7;

-- find the name of people who's interview says something about bakery
SELECT name, transcript
FROM interviews
WHERE transcript
LIKE '%bakery%';

-- Find the license plate and its owner at the local at the time 10:25 (10 minutes after the theft)
SELECT name, phone_number, passport_number, bsl.license_plate
FROM people p
JOIN bakery_security_logs bsl ON bsl.license_plate = p.license_plate
WHERE hour = 10
AND minute < 25
AND minute > 15
AND activity = 'exit';

-- find the name of the thief based on interview of Eugene
SELECT name
FROM people p
JOIN bank_accounts ba ON ba.person_id = p.id
JOIN atm_transactions atm ON atm.account_number = ba.account_number
WHERE atm.transaction_type = 'withdraw'
AND atm.atm_location = 'Leggett Street'
AND atm.year = 2021
AND atm.day = 28
AND atm.month = 7
ORDER BY name;

-- join license_plates found before with the names found now to see name and number of suspects
SELECT name, phone_number
FROM people p
JOIN bank_accounts ba ON ba.person_id = p.id
JOIN atm_transactions atm ON atm.account_number = ba.account_number
JOIN bakery_security_logs bsl ON bsl.license_plate = p.license_plate
WHERE atm.transaction_type = 'withdraw'
AND atm.atm_location = 'Leggett Street'
AND atm.year = 2021
AND atm.day = 28
AND atm.month = 7
AND hour = 10
AND minute < 25
AND minute > 15
AND activity = 'exit'
ORDER BY name;

-- find the number of people that called someone in 07/28/2021 with less than 1 minute duration as the interview says
SELECT caller, receiver, duration
FROM phone_calls
WHERE day = 28
AND year = 2021
AND month = 7
AND duration < 60;

-- join suspects with numbers found before
SELECT name, phone_number
FROM people p
JOIN bank_accounts ba ON ba.person_id = p.id
JOIN atm_transactions atm ON atm.account_number = ba.account_number
JOIN bakery_security_logs bsl ON bsl.license_plate = p.license_plate
JOIN phone_calls pc ON pc.caller = p.phone_number
WHERE atm.transaction_type = 'withdraw'
AND atm.atm_location = 'Leggett Street'
AND atm.year = 2021
AND atm.day = 28
AND atm.month = 7
AND hour = 10
AND minute < 25
AND minute > 15
AND bsl.activity = 'exit'
AND pc.duration < 60
ORDER BY name;


-- find the flight where Bruce and Diana was at the day after the theft
SELECT *
FROM passengers pa
JOIN people p ON p.passport_number = pa.passport_number
JOIN flights fl ON fl.id = pa.flight_id
WHERE name
IN ('Bruce', 'Diana')
AND year = 2021
AND day = 29
AND month = 7
ORDER BY hour, minute;
-- as the interviewer says that the thief picks up the earlier flight we can assume that Bruce is the thief

-- find the city which he left to
SELECT city
FROM airports air
JOIN flights fl ON fl.destination_airport_id = air.id
WHERE fl.id = 36;
-- found New York City

-- find who the thief called to (he's accomplice)
SELECT name
FROM people p
JOIN phone_calls pc ON pc.receiver = p.phone_number
WHERE caller = '(367) 555-5533'
AND day = 28
AND month = 7
AND year = 2021
AND duration < 60;
-- with that we found that Robin is the accomplice

