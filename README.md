# GPU_Programming

### №1

- Написать программу для сложения двух векторов, выполняемую на GPU
(использовать программные конструкции из примера в первой лекции). 
- Построить графики зависимости времени вычисления от размерности векторов N в диапазоне от 1<<10 до 1<<23,
при различных конфигурациях нитей. Оформить результаты в форме отчета (электронные
документы, без распечатывания).

> LAB_One

### №2

Выполнить задание лабораторной №1, используя Events и nvprof.

> LAB_Two

### №3

#### 3.1
- определить для своего устройства зависимость теоретической заполняемости
мультипроцессоров от числа нитей в блоке;
- для программы инициализации вектора определить достигнутую заполняемость в
зависимости от длины вектора.

#### 3.2
- применяя двумерную индексацию нитей в блоке и блоков в гриде написать программу
инициализации матрицы, сравнить эффективность кода ядра при двух различных
линейных индексациях массива;
- написать программу транспонирования матрицы.

> LAB_Three

### №4
- написать программу транспонирования матриц, реализующую алгоритм
без использования разделяемой памяти, наивный алгоритм с
использованием разделяемой памяти и алгоритм с разрешением
конфликта банков разделяемой памяти;
- провести профилирование программы с использованием nvprof или nvpp -
сравнить время выполнения ядер, реализующих разные алгоритмы, и
оценить эффективность использования разделяемой памяти.

> LAB_Four

### №5
- реализовать алгоритм вычисления интеграла функции, заданной на прямоугольной
сетке в трехмерном пространстве, на сфере с использованием текстурной и
константной памяти;
- реализовать алгоритм вычисления интеграла функции, заданной на прямоугольной
сетке в трехмерном пространстве, на сфере без использованием текстурной и
константной памяти (ступенчатую и линейную интерполяцию в узлы квадратуры на
сфере реализовать программно);
- сравнить результаты и время вычислений обоими способами.

> LAB_Five

### №6
- разработать и программно реализовать алгоритм для сравнения производительности
копирования устройство->хост (и наоборот) данных, размещенных в памяти
выделенной на хосте обычным образом и с использованием закрепленных страниц ;
- подобрать оптимальный размер порции данных для реализации сложения векторов с
использованием потоков CUDA для распараллеливания копирования и выполнения;
- то же для реализации скалярного умножения.

> LAB_Six1, LAB_Six2

### №7
- программно реализовать алгоритм решения уравнения переноса на основе разностной схемы «вверх по потоку» с
использованием библиотеки Thrust и без её использования (сырой код CUDA C).
- Сравнить производительность реализаций.

> LAB_Seven

### №8
- сравните производительность программ, реализующих saxpy на основе
библиотек thrust и cuBLAS.
- выявите периодичность солнечной активности, опираясь на данные
наблюдений о числе Вольфа, представленные по адресу:
http://www.gaoran.ru/database/csa/daily_wolf_r.html

> LAB_8_1, LAB8_2