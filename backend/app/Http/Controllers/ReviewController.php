<?php

namespace App\Http\Controllers;

use App\Models\Review;
use App\Models\ReviewFoto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ReviewController extends Controller
{
    public function index()
    {
        $review = Review::with(['pembayaran', 'hotel', 'foto'])->get();

        return response()->json([
            'message' => 'Data review berhasil diambil',
            'data' => $review
        ], 200);
    }

    public function show($id)
    {
        $review = Review::with(['pembayaran', 'hotel', 'foto'])->find($id);

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
        $review = Review::with(['pembayaran.booking.user', 'hotel', 'foto'])
            ->where('id_hotel', $id_hotel)
            ->get();

        // Format response dengan data user dan foto
        $formatted = $review->map(function ($item) {
            $user = $item->pembayaran?->booking?->user;
            return [
                'id_review' => $item->id_review,
                'id_pembayaran' => $item->id_pembayaran,
                'id_hotel' => $item->id_hotel,
                'rating' => $item->rating,
                'keterangan' => $item->keterangan,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
                'user' => $user ? [
                    'id_user' => $user->id_user,
                    'nama' => $user->nama,
                    'foto_profil' => $user->foto_profil,
                ] : null,
                'hotel' => $item->hotel,
                'foto' => $item->foto->map(function ($f) {
                    return [
                        'id_review_foto' => $f->id_review_foto,
                        'url_foto' => $f->url_foto,
                    ];
                }),
            ];
        });

        return response()->json([
            'message' => 'Data review hotel berhasil diambil',
            'data' => $formatted
        ], 200);
    }

    public function saveRating(Request $request)
    {
        $request->validate([
            'id_pembayaran' => 'required|integer|exists:pembayaran,id_pembayaran',
            'id_hotel' => 'required|integer|exists:hotel,id_hotel',
            'rating' => 'required|integer|min:1|max:5'
        ]);

        // Cek apakah sudah ada review untuk pembayaran ini
        $review = Review::where('id_pembayaran', $request->id_pembayaran)->first();

        if ($review) {
            $review->update([
                'rating' => $request->rating,
            ]);
        } else {
            $review = Review::create([
                'id_pembayaran' => $request->id_pembayaran,
                'id_hotel' => $request->id_hotel,
                'rating' => $request->rating,
            ]);
        }

        return response()->json([
            'message' => 'Rating berhasil disimpan',
            'data' => $review
        ], 200);
    }

    public function updateKeterangan(Request $request, $id)
    {
        $request->validate([
            'keterangan' => 'nullable|string'
        ]);

        $review = Review::find($id);

        if (!$review) {
            return response()->json([
                'message' => 'Review tidak ditemukan'
            ], 404);
        }

        $review->update([
            'keterangan' => $request->keterangan
        ]);

        return response()->json([
            'message' => 'Ulasan berhasil diperbarui',
            'data' => $review
        ], 200);
    }

    public function byPembayaran($id_pembayaran)
    {
        $review = Review::with(['pembayaran.booking.user', 'hotel', 'foto'])
            ->where('id_pembayaran', $id_pembayaran)
            ->first();

        if (!$review) {
            return response()->json([
                'message' => 'Review tidak ditemukan',
                'data' => null
            ], 200);
        }

        $user = $review->pembayaran?->booking?->user;

        $formatted = [
            'id_review' => $review->id_review,
            'id_pembayaran' => $review->id_pembayaran,
            'id_hotel' => $review->id_hotel,
            'rating' => $review->rating,
            'keterangan' => $review->keterangan,
            'created_at' => $review->created_at,
            'updated_at' => $review->updated_at,
            'user' => $user ? [
                'id_user' => $user->id_user,
                'nama' => $user->nama,
                'foto_profil' => $user->foto_profil,
            ] : null,
            'foto' => $review->foto->map(function ($f) {
                return [
                    'id_review_foto' => $f->id_review_foto,
                    'url_foto' => $f->url_foto,
                ];
            }),
        ];

        return response()->json([
            'message' => 'Data review berhasil diambil',
            'data' => $formatted
        ], 200);
    }

    public function uploadFoto(Request $request, $id)
    {
        $request->validate([
            'foto' => 'required|array',
            'foto.*' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
        ]);

        $review = Review::find($id);

        if (!$review) {
            return response()->json([
                'message' => 'Review tidak ditemukan'
            ], 404);
        }

        // Hitung foto yang sudah ada
        $existingCount = $review->foto()->count();
        $newCount = count($request->file('foto'));
        $totalCount = $existingCount + $newCount;

        if ($totalCount > 5) {
            return response()->json([
                'message' => 'Maksimal 5 foto per review. Sudah ada ' . $existingCount . ' foto.'
            ], 422);
        }

        $uploaded = [];

        foreach ($request->file('foto') as $file) {
            $path = $file->store('review-foto', 'public');

            $reviewFoto = ReviewFoto::create([
                'id_review' => $review->id_review,
                'url_foto' => $path,
            ]);

            $uploaded[] = [
                'id_review_foto' => $reviewFoto->id_review_foto,
                'url_foto' => $path,
            ];
        }

        return response()->json([
            'message' => 'Foto berhasil diupload',
            'data' => $uploaded
        ], 200);
    }

    public function hapusFoto($id_foto)
    {
        $foto = ReviewFoto::find($id_foto);

        if (!$foto) {
            return response()->json([
                'message' => 'Foto tidak ditemukan'
            ], 404);
        }

        // Hapus file dari storage
        Storage::disk('public')->delete($foto->url_foto);

        $foto->delete();

        return response()->json([
            'message' => 'Foto berhasil dihapus'
        ], 200);
    }
}