<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_user' => 'required|integer',
            'check_in' => 'required|date',
            'check_out' => 'required|date|after_or_equal:check_in',
            'total_harga' => 'required|numeric'
        ]);

        $booking = Booking::create([
            'id_user' => $request->id_user,
            'tgl_booking' => now(),
            'check_in' => $request->check_in,
            'check_out' => $request->check_out,
            'total_harga' => $request->total_harga,
            'status' => 'pending'
        ]);

        return response()->json([
            'message' => 'Booking berhasil dibuat',
            'data' => $booking
        ], 201);
    }

    public function userBooking($id_user)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $id_user)
        ->get();

        return response()->json([
            'message' => 'Data booking user berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function index()
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])->get();

        return response()->json([
            'message' => 'Semua data booking berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function show($id)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])->find($id);

        if (!$booking) {
            return response()->json([
                'message' => 'Booking tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail booking berhasil diambil',
            'data' => $booking
        ], 200);
    }
}