<?php

namespace App\Http\Controllers;

use App\Models\Review;

class ReviewController extends Controller
{
    public function store(Request $request)
    {
        $review = Review::create([
            'id_pembayaran' => $request->id_pembayaran,
            'id_hotel' => $request->id_hotel,
            'rating' => $request->rating,
            'keterangan' => $request->keterangan
        ]);

        return response()->json($review);
    }
}