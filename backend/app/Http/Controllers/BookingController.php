<?php

namespace App\Http\Controllers;

use App\Models\Booking;

class BookingController extends Controller
{
    public function store(Request $request)
    {
        $booking = Booking::create([
            'id_user' => $request->id_user,
            'tgl_booking' => now(),
            'check_in' => $request->check_in,
            'check_out' => $request->check_out,
            'total_harga' => $request->total_harga,
            'status' => 'pending'
        ]);

        return response()->json($booking);
    }

    public function userBooking($id_user)
    {
        return Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user',$id_user)
        ->get();
    }
}