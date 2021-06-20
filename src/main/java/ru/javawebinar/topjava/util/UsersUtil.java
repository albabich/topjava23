package ru.javawebinar.topjava.util;

import ru.javawebinar.topjava.model.Role;
import ru.javawebinar.topjava.model.User;

import java.util.Arrays;
import java.util.List;

public class UsersUtil {
    public static List<User> users = Arrays.asList(
            new User(1, "admin", "admin@gmail.com", "adminpass", Role.ADMIN),
            new User(2, "user", "user@mail.ru", "userpass", Role.ADMIN)
    );
}
