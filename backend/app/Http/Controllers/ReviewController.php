<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        $review = Review::with(['pembayaran', 'hotel'])->get();

        return response()->json([
            'message' => 'Data review berhasil diambil',
            'data' => $review
        ], 200);
    }

    public function show($id)
    {
        $review = Review::with(['pembayaran', 'hotel'])->find($id);

        if (!$review) {
            return response()->json([
                'message' => 'Review tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail review berhasil diambil',
            'data' => $review
        ], 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_pembayaran' => 'required|integer|exists:pembayaran,id_pembayaran',
            'id_hotel' => 'required|integer|exists:hotel,id_hotel',
            'rating' => 'required|integer|min:1|max:5',
            'keterangan' => 'nullable|string'
        ]);

        $review = Review::create([
            'id_pembayaran' => $request->id_pembayaran,
            'id_hotel' => $request->id_hotel,
            'rating' => $request->rating,
            'keterangan' => $request->keterangan
        ]);

        return response()->json([
            'message' => 'Review berhasil ditambahkan',
            'data' => $review
        ], 201);
    }

    public function byHotel($id_hotel)
    {
        $review = Review::with(['pembayaran', 'hotel'])
            ->where('id_hotel', $id_hotel)
            ->get();

        return response()->json([
            'message' => 'Data review hotel berhasil diambil',
            'data' => $review
        ], 200);
    }
}