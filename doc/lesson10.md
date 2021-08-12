# Стажировкаа <a href="https://github.com/JavaWebinar/topjava">TopJava</a>

## [Материалы занятия](https://drive.google.com/open?id=0B9Ye2auQ_NsFfk43cG91Yk9pM3JxUHVhNFVVdHlxSlJtZm5oY3A4YXRtNk1KWEZxRlFNeW8)

### ![correction](https://cloud.githubusercontent.com/assets/13649199/13672935/ef09ec1e-e6e7-11e5-9f79-d1641c05cbe6.png) Правки в проекте

#### Apply 10_0_fix.patch
- Поправил имена html аттрибутов на [low-case через дефисы](https://stackoverflow.com/questions/41465852/548473)
- Добавил [CASCADE на стороне @OneToMany](https://stackoverflow.com/a/44988100/548473). Это имеет значение, если мы будем генерировать таблицы из кода.
- Правки тестов

## ![hw](https://cloud.githubusercontent.com/assets/13649199/13672719/09593080-e6e7-11e5-81d1-5cb629c438ca.png) Разбор домашнего задания HW9

### ![video](https://cloud.githubusercontent.com/assets/13649199/13672715/06dbc6ce-e6e7-11e5-81a9-04fbddb9e488.png) 1. <a href="https://drive.google.com/open?id=0B9Ye2auQ_NsFZnQ2dDZsT0dvYjQ">HW9</a>

<details>
  <summary><b>Краткое содержание</b></summary>

Создаем `MealUIController`, `MealTo` у нас используется только в списке еды для выбора цвета строки в зависимости от `MealTo.excess`. 
Для полей `Meal` добавляем аннотацию форматирования даты `@DateTimeFormat`.
Валидация в приложении происходит после биндинга - сначала из параметров запроса через сеттеры собирается объект, затем делается проверка на поля объекта.
Чтобы валидация калорий на null работала, меняем тип `calories` на `Integer` и не забываем менять тип в `setCalories` -
тогда при `calories=null` объект соберется без `NullPointerException (NPE)`.  

Для работы по Ajax в `MealUIController` добавим GET метод получения еды по ее `id`. Метод 
`#createOrUpdate` реализован так же, как и в `AdminUIController` - метод
принимает `@Valid Meal` и результат валидации `BindingResult`.  

Так как в `RootController` при запросе в методах теперь просто происходит
перенаправление на нужную JSP-страницу, а `Datatables` сама получает необходимые
данные - удалим из параметров и тела `getMeals` ненужные больше `Model` и операции с ней.  

Конфигурация отрисовки таблицы еды в `topjava.meals.js` аналогична `topjava.users.js`.
Так как с сервера `dateTime` в списке еды приходит в формате ISO, 
для отображения ее в таблице определим функцию, которая будет заменять буквау `Т` в 
строке с датой на пробел и отрезать секунды.
В функции отрисовки строки `createdRow` добавим к каждой строке атрибут `data-meal-excess` со значением `excess` - по нему в `style.css` определяется цвет.  

Теперь в `meals.jsp` можно удалить таблицу, она будет отрисовываться с помощью `dataTables`.  
В форме создания и редактирования еды нужно обратить внимание на то, что атрибут `name`
поля формы и название полей `Meal` должны строго
совпадать, иначе биндинг для этих полей происходить не будет.

В js я сделал рефакторинг - вынес общую часть конфигурации и создание `DataTable` в `topjava.common.js`. Теперь в `makeEditable` я передаю не объект `DataTable`, а часть ее конфигурации,
которая склеивается с общей частью через [`jQuery $.extend`](https://api.jquery.com/jquery.extend/#jQuery-extend-deep-target-object1-objectN)

### Тесты
В `RootControllerTest.getMeals` добавляем авторизацию и убираем проверку модели.
Во всех тестовых методах `MealRestControllerTest` к запросам добавляем авторизацию 
(по аналогии с тестами пользователей). Также добавляем тест на неавторизованный доступ - 
в нем проверяем, что запрос без авторизации вернет статус `status().isUnauthorized`.  

### Datetime-picker  
Из примера по ссылке к домашнему заданию возьмем пример реализации `datetime-picker`. 
Адаптируем его к нашей странице - отдельно вынесем `start/end` переменные и добавим параметр `formatDate`.  
Чтобы в форме создания и редактирования еды дата отображалась не в формате ISO (без буквы "T"),
в `topjava.common#updateRow` добавим проверку и JSON поле данных `dateTime` форматируем через `formatDate` (вынесли в отдельную функцию).  
Дата из формы будет приходить в параметрах POST в `MealUIController#createOrUpdate` также не в ISO. Поменяем формат в `@DateTimeFormat` на "yyyy-MM-dd HH:mm" 
</details>

#### Apply 10_01_HW9_binding_ajax.patch

Datatables перевели на ajax (`"ajax": {"url": ajaxUrl, ..`), те при отрисовке таблица сама по этому url запрашивает данные. Поэтому в методе `RootController.meals()` нам нужно только возвратить view "meals" (`meals.jsp`) которому уже не нужны данные в атрибутах.

> - JavaScript `i18n[]` локализацию перенес в `i18n.jsp` и передаю туда `page` как параметр
>   - [JSP include action with parameter example](https://beginnersbook.com/2013/12/jsp-include-with-parameter-example)
> - Вынес общий код в `ValidationUtil.getErrorResponse()` и сделал обработку через `stream()`
> - Вместо контекста передаю в `makeEditable` опции `DataTable`.
> - Вынес создание `DataTable` в `topjava.common.js`. В параметр конфигурации добавляю общие опции используя [jQuery.extend()](https://api.jquery.com/jquery.extend/#jQuery-extend-deep-target-object1-objectN)

#### Apply 10_02_HW9_test.patch

#### Apply 10_03_HW9_datetimepicker.patch
> - Вынес форматирование даты в `topjava.common.formatDate()` 
> - Изменил формат ввода dateTime в форме без 'T': при биндинге значений к полям формы в `topjava.common#updateRow()` для поля `dateTime` вызываю `formatDate()`.  
    REST интерфейс по прежнему работает в стандарте ISO-8601
> - В новой версии `datetimepicker` работает ограничение выбора времени `startTime/endTime`
> - Добавил `autocomplete="off"` для выключения автоподстановки (у некоторых участников мешает вводу, у меня не воспроизводится)

- <a href="http://xdsoft.net/jqplugins/datetimepicker/">DateTimePicker jQuery plugin</a>
- <a href="https://github.com/xdan/datetimepicker/issues/216">Datetimepicker and ISO-8601</a>

## Занятие 10:

### Не успел, выйдет сегодня. Сделаю оповещение в Slack и рассылку письма. 

## ![hw](https://cloud.githubusercontent.com/assets/13649199/13672719/09593080-e6e7-11e5-81d1-5cb629c438ca.png) Домашнее задание HW10
- 1: Сделать валидацию в `AdminUIController/MealUIController` через `ExceptionInfoHandler`. Вернуть клиенту `ErrorInfo` и статус `HttpStatus.UNPROCESSABLE_ENTITY` (тип методов контроллеров сделать `void`). Ошибки валидации отобразить на клиенте красиво (так, как это сделано в [demo](http://topjava.herokuapp.com), без локализации полей)
- 2: Сделать валидацию принимаемых json объектов в REST контроллерах через `ExceptionInfoHandler`. Добавить в Rest контроллеры тест для невалидных данных.
  - <a href="https://dzone.com/articles/spring-31-valid-requestbody">@Valid @RequestBody + Error handling</a>
- 3: Сделать обработку ошибки при дублирования email (вывод сообщения "User with this email already exists") для: 
  - 3.1 регистрации / редактирования профиля пользователя
  - 3.2 добавления / редактирования пользователя в таблице
  - 3.3 REST контроллеров  
  Варианты выполнения:
    - через `catch DataIntegrityViolationException`
    - обработку ошибок в  `@ExceptionHandler`(https://stackoverflow.com/a/42422568/548473)
    - более сложная реализация - [собственный валидатор](https://coderlessons.com/articles/java/spring-mvc-validator-i-initbinder)  
  - Опционально - [сделать локализацию выводимой ошибки](https://www.logicbig.com/tutorials/spring-framework/spring-core/message-sources.html)

### Optional
- 4: Сделать обработку ошибки при дублирования dateTime еды. Сделать тесты на дублирование email и dateTime.
  - [Тесты на DB exception c @Transactional](http://stackoverflow.com/questions/37406714/548473)
  - [Сheck String in response body with mockMvc](https://stackoverflow.com/questions/18336277/548473)
- 5: Сделать в приложении выбор локали (см. http://topjava.herokuapp.com/)
  - [Internationalization](https://terasolunaorg.github.io/guideline/5.0.x/en/ArchitectureInDetail/Internationalization.html)
  -  <a href="http://www.mkyong.com/spring-mvc/spring-mvc-internationalization-example">Spring MVC internationalization sample</a>
  -  <a href="https://www.concretepage.com/spring-4/spring-mvc-internationalization-localization">Spring 4 MVC Internationalization</a>
- 6: Починить UTF-8 в редактировании профиля и регистрации (если кодировка по умолчанию у вас не UTF-8). Подумайте, почему кодировка поломалась.
  
-------

## ![error](https://cloud.githubusercontent.com/assets/13649199/13672935/ef09ec1e-e6e7-11e5-9f79-d1641c05cbe6.png) Типичные ошибки и подсказки по реализации
- 1: `ErrorInfo` просто бин для передачи информации на клиента. Кода возврата и ответ настраиваются в `ExceptionInfoHandler`.
- 2: Не дублируйте обработку ошибок `BindingResult`: `result.getFieldErrors()..` 
- 3: Можно не создавать собственные эксепшены, а в `ExceptionInfoHandler` ловить стандартные 
- 4: в `MethodArgumentNotValidException` также есть `e.getBindingResult()`, его можно обрабатывать по аналогии с `BindException`
- 5: Не дублируйте код переключения локали на странице логина и в приложении
- 6: При проблемах с валидацией `Meals` в `MealRestController`, посмотрите на валидацию в `MealUIController.updateOrCreate`
- 7: Импорт класса `java.net.BindException` вместо нужного `javax.validation.BindException`
