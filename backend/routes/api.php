<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\HotelController;
use App\Http\Controllers\PembayaranController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\UserController;

Route::get('/booking', [BookingController::class, 'index']);
Route::get('/booking/{id}', [BookingController::class, 'show']);
Route::post('/booking', [BookingController::class, 'store']);
Route::get('/booking/user/{id}', [BookingController::class, 'userBooking']);

Route::get('/hotel/search', [HotelController::class, 'search']);
Route::get('/hotel', [HotelController::class, 'index']);
Route::get('/hotel/{id}', [HotelController::class, 'show']);

Route::post('/pembayaran', [PembayaranController::class, 'store']);
Route::get('/pembayaran/{id}', [PembayaranController::class, 'show']);

Route::get('/review', [ReviewController::class, 'index']);
Route::get('/review/{id}', [ReviewController::class, 'show']);
Route::post('/review', [ReviewController::class, 'store']);
Route::get('/review/hotel/{id_hotel}', [ReviewController::class, 'byHotel']);

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);
Route::post('/google-login', [UserController::class, 'googleLogin']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [UserController::class, 'profile']);
    Route::post('/logout', [UserController::class, 'logout']);
});

