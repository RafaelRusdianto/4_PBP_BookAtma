<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\HotelController;
use App\Http\Controllers\PembayaranController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\UserController;

Route::get('/booking', [BookingController::class, 'index']);
Route::get('/booking/{id}', [BookingController::class, 'show']);
Route::get('/booking/user/{id}', [BookingController::class, 'userBooking']);

Route::get('/hotel', [HotelController::class, 'index']);
Route::get('/hotel/search', [HotelController::class, 'search']);
Route::get('/hotel/{id}', [HotelController::class, 'show']);

Route::get('/pembayaran/{id}', [PembayaranController::class, 'show']);

Route::get('/review', [ReviewController::class, 'index']);
Route::get('/review/{id}', [ReviewController::class, 'show']);
Route::post('/review', [ReviewController::class, 'store']);
Route::get('/review/hotel/{id_hotel}', [ReviewController::class, 'byHotel']);
Route::post('/review/rating', [ReviewController::class, 'saveRating']);
Route::put('/review/{id}/keterangan', [ReviewController::class, 'updateKeterangan']);
Route::get('/review/pembayaran/{id_pembayaran}', [ReviewController::class, 'byPembayaran']);
Route::post('/review/{id}/upload-foto', [ReviewController::class, 'uploadFoto']);
Route::delete('/review/foto/{id_foto}', [ReviewController::class, 'hapusFoto']);
Route::put('/review/{id}', [ReviewController::class, 'update']);
Route::delete('/review/{id}', [ReviewController::class, 'destroy']);

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);
Route::post('/google-login', [UserController::class, 'googleLogin']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [UserController::class, 'profile']);
    Route::post('/profile', [UserController::class, 'updateProfile']);
    Route::post('/logout', [UserController::class, 'logout']);

    Route::post('/booking', [BookingController::class, 'store']);
    Route::post('/pembayaran', [PembayaranController::class, 'store']);
    Route::get('/bookings/active', [BookingController::class, 'active']);
    Route::get('/bookings/history', [BookingController::class, 'history']);
    Route::get('/bookings/{id}', [BookingController::class, 'show']);
});

