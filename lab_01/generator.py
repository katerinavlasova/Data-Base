import random
import datetime
number = 1000

def generate_driving_schools(num):
    school = []
    for i in range(num):
        school_name = random.choice(('Start', 'Neva', 'Green_light', 'R-auto',
                       'Unit', 'Luxury', 'Autoprava.pro', 'Mask',
                       'DOSAAF', 'Priority', 'East', 'Young', 'Spectr'))
        rating = random.choice((1, 2, 3, 4, 5))
        number = ''.join([str((random.randint(0, 9))) for i in range(9)])
        number += '98'
        school.append((i, school_name, rating, number[::-1]))
    return school
def generate_cars(num):
    cars = []
    for i in range(num):
        year = random.randint(2005, 2019)
        car_type = random.randint(0, 1)
        transmission = ''
        car_make = ''
        if car_type == 1:
            transmission = 'Mechanics'
            car_make = random.choice(('Renault Logan I', 'Skoda Octavia I', 'Mitsubishi Eclipse I',
                                     'Geely Emgrand EC7', 'Volkswagen Polo V', 'Kia Rio II',
                                     'MINI Countryman II', 'Hyundai Solaris I', 'Chevrolet Lacetti',
                                     'УАЗ Patriot Sport I 3164', 'Mitsubishi Pajero II', 'MINI Hatch II',
                                     'Citroen C3 I', 'Citroen C-Elysee I', 'Ford Focus II'))
        else:
            transmission = 'Automatic'
            car_make = random.choice(('Hyundai Creta I', 'Volvo XC90 I', 'Opel Astra H',
                                     'Skoda Rapid I', 'Infiniti FX I (S50)', 'Mitsubishi Lancer X',
                                     'Hyundai Santa Fe I Classic', 'Volvo V70 II ', 'Volvo XC90 I'
                                     'Nissan Tiida I', 'Land Rover Discovery Sport I', 'Honda CR-V I',
                                     'Jaguar X-Type I', 'Subaru Outback II', 'SsangYong Actyon II'))
        cars.append((i, car_make, transmission, year))
    return cars
def generate_instuctor(num):
    instructor = []
    name = ['Ekaterina', 'Oleg', 'Artem', 'Alexey', 'Elena', 'Nikita', 'Achmed', 'Valentin',
                'Sonya', 'Alexandr', 'Dmitriy', 'Vladislav', 'Avetis']
    surname = ['Kornienko', 'Grechko', 'Bobr', 'Fischer', 'Kot', 'Pogrebnyak',
                   'Rozental', 'Erochevich', 'Ossa', 'Meuler', 'Chernych', 'Meye']
    for i in range(num):
        driving_experience = random.randint(3, 50)
        teaching_experience = random.randint(3, driving_experience)
        instructor.append((i, random.choice(surname), random.choice(name), driving_experience,
                           teaching_experience))
    return instructor
def generate_student(num, instructor_number, car_number, school_number):
    students = []
    name = ['Marina', 'Oleg', 'Artem', 'Alexey', 'Elena', 'Nikita', 'Achmed', 'Valentin',
                'Sonya', 'Alexandr', 'Dmitriy', 'Vladislav', 'Maria', 'Anastasia']
    surname = ['Kornienko', 'Grechko', 'Bobr', 'Fischer', 'Kot', 'Pogrebnyak',
                   'Rozental', 'Erochevich', 'Ossa', 'Meuler', 'Chernych', 'Meye']
    group = ['Day group', 'Evening group']
    for i in range(num):
        practiced_hours = random.randint(0,56)
        instructor_id = random.randint(0, instructor_number - 1)
        car_id = random.randint(0, car_number - 1)
        school_id = random.randint(0, school_number - 1)
        students.append((i, random.choice(surname), random.choice(name), random.choice(group),
                         practiced_hours, instructor_id, car_id, school_id))
    return students

school = generate_driving_schools(number)
school_file = open('schools.txt', 'w')
for i in range(number):
    school_file.write('{} | {} | {} | {}\n'.format(*school[i]))
school_file.close()

car = generate_cars(number)
car_file = open('cars.txt', 'w')
for i in range(number):
    car_file.write('{} | {} | {} | {}\n'.format(*car[i]))
car_file.close()

instructors = generate_instuctor(number)
instructor_file = open('instructors.txt', 'w')
for i in range(number):
    instructor_file.write('{} | {} | {} | {} | {} \n'.format(*instructors[i]))
instructor_file.close()

students = generate_student(number, len(instructors), len(car), len(school))
student_file = open('students.txt', 'w')
for i in range(number):
    student_file.write('{} | {} | {} | {} | {} | {} | {} | {}\n'.format(*students[i]))
student_file.close()
