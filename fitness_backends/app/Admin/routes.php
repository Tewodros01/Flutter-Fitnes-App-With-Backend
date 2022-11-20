<?php

use Illuminate\Routing\Router;

Admin::routes();

Route::group([
    'prefix'        => config('admin.route.prefix'),
    'namespace'     => config('admin.route.namespace'),
    'middleware'    => config('admin.route.middleware'),
    'as'            => config('admin.route.prefix') . '.',
], function (Router $router) {

    $router->get('/', 'HomeController@index')->name('home');
    $router->resource('books', BookController::class);
    $router->resource('book-types', BookTypeController::class);
    $router->resource('workouts', WorkoutController::class);
    $router->resource('workout-types', WorkoutTypeController::class);
    $router->resource('users', UserController::class);
    $router->resource('tempratures', TempratureController::class);

});
