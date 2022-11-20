<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::post('/register', 'App\Http\Controllers\UserController@register');
Route::post('/login', 'App\Http\Controllers\UserController@login');
Route::get('/user', 'App\Http\Controllers\UserController@getCurrentUser');
Route::post('/update', 'App\Http\Controllers\UserController@update');
Route::post('/likeworkout', 'App\Http\Controllers\UserController@likeWorkout');
Route::post('/dislikeworkout', 'App\Http\Controllers\UserController@disLikeWorkout');
Route::post('/likebook', 'App\Http\Controllers\UserController@likeBook');
Route::post('/disLikebook', 'App\Http\Controllers\UserController@disLikeBook');
Route::get('/logout', 'App\Http\Controllers\UserController@logout');
Route::get('/refresh', 'App\Http\Controllers\UserController@token');


Route::get('/allworkout/', 'App\Http\Controllers\WorkoutController@getAllWorkout');
Route::get('/allworkoutbycategory/', 'App\Http\Controllers\WorkoutController@getWorkoutByCategory');
Route::get('/allsimpleworkout/', 'App\Http\Controllers\WorkoutController@getSimpleWorkout');
Route::get('/allsearchworkout/', 'App\Http\Controllers\WorkoutController@getAllSearchWorkout');
Route::get('/alllikedworkout/', 'App\Http\Controllers\WorkoutController@getAllLikeWorkout');
Route::get('/alllikeworkout/', 'App\Http\Controllers\UserWorkoutController@getLikeWorkout');

Route::get('/allbook/', 'App\Http\Controllers\BookController@getAllBook');
Route::get('/allsearchbook/', 'App\Http\Controllers\BookController@getAllSearchBook');
Route::get('/allbookbycategory/', 'App\Http\Controllers\BookController@getBookByCategory');
Route::get('/alllikedbook/', 'App\Http\Controllers\BookController@getAllLikeBook');
Route::get('/recommendedbook/', 'App\Http\Controllers\BookController@getRecommended');
Route::get('/alllikebook/', 'App\Http\Controllers\UserBookController@geLikeBook');

Route::get('/gettemp/', 'App\Http\Controllers\TempratureController@getTemprature');

