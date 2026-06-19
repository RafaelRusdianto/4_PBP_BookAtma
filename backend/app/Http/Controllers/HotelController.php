<?php

namespace App\Http\Controllers;

use App\Models\Hotel;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    public function index()
    {
        $hotel = Hotel::with(['foto'])->get();

        return response()->json([
            'message' => 'Data hotel berhasil diambil',
            'data' => $hotel
        ], 200);
    }

    public function show($id)
    {
        $hotel = Hotel::with([
            'kamar.fasilitas',
            'kamar.foto',
            'review'
        ])->find($id);

        if (!$hotel) {
            return response()->json([
                'message' => 'Hotel tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail hotel berhasil diambil',
            'data' => $hotel
        ], 200);
    }

    public function search(Request $request)
    {
        $keyword = $request->query('keyword');
        $guest = $request->query('guest');
        $checkIn = $request->query('check_in');
        $checkOut = $request->query('check_out');
        $currentProvince = $request->query('current_province');
        $minRating = $request->query('min_rating');

        // Deteksi otomatis: kalau keyword adalah angka, treat sebagai rating filter
        // if ($keyword && is_numeric($keyword)) {
        //     $minRating = $keyword;
        //     $keyword = null;
        // }

        // Deteksi: kalau keyword cocok dengan nama fasilitas → cari by facility
        // $facilityHotels = null;
        // if ($keyword) {
        //     $facilityHotels = Hotel::whereHas('kamar.fasilitas', function ($q) use ($keyword) {
        //         $q->where('nama_fasilitas', 'like', '%' . $keyword . '%');
        //     })->pluck('id_hotel');
        // }


        $roomFilter = function ($kamarQuery) use ($guest, $checkIn, $checkOut) {
            $kamarQuery->where('status', 'available');

            if ($guest) {
                $kamarQuery->where('kapasitas', '>=', $guest);
            }

            if ($checkIn && $checkOut) {
                $kamarQuery->whereDoesntHave('detailBooking.booking', function ($bookingQuery) use ($checkIn, $checkOut) {
                    $bookingQuery
                        ->whereNotIn('status', ['cancelled', 'canceled', 'dibatalkan'])
                        ->whereDate('check_in', '<', $checkOut)
                        ->whereDate('check_out', '>', $checkIn);
                });
            }
        };

        $hotel = Hotel::with([
            'foto',
            'provinsi',
            'kamar' => function ($query) use ($roomFilter) {
                $roomFilter($query);
                $query->with(['foto', 'fasilitas']);
            },
        ])
            ->when($currentProvince, function ($query) use ($currentProvince) {
                $query->where(function ($subQuery) use ($currentProvince) {
                    $subQuery
                        ->where('alamat', 'like', '%' . $currentProvince . '%')
                        ->orWhereHas('provinsi', function ($provinsiQuery) use ($currentProvince) {
                            $provinsiQuery->where('nama_provinsi', 'like', '%' . $currentProvince . '%');
                        });
                });
            })
            ->when(!$currentProvince && $keyword, function ($query) use ($keyword) {
                $query->where(function ($subQuery) use ($keyword) {
                    $subQuery
                        ->where('nama', 'like', '%' . $keyword . '%')
                        ->orWhere('alamat', 'like', '%' . $keyword . '%')
                        ->orWhereHas('provinsi', function ($provinsiQuery) use ($keyword) {
                            $provinsiQuery->where('nama_provinsi', 'like', '%' . $keyword . '%');
                        });
                });
            })
            ->whereHas('kamar', $roomFilter)
            ->when($keyword && !$currentProvince, function ($query) use ($keyword) {
                $query->orderByRaw(
                    "CASE 
                        WHEN nama LIKE ? THEN 0
                        WHEN alamat LIKE ? THEN 1
                        ELSE 2
                    END",
                    [
                        '%' . $keyword . '%',
                        '%' . $keyword . '%',
                    ]
                );
            })
            // ->when($minRating, function ($query) use ($minRating) {
            //     $query->where('avg_rating', '>=', (float) $minRating);
            // })
            // ->when($keyword && $facilityHotels?->isNotEmpty(), function ($query) use ($facilityHotels) {
            //     $query->whereIn('id_hotel', $facilityHotels);
            // })
            ->orderByDesc('avg_rating')
            ->get();

        return response()->json([
            'message' => 'Hasil pencarian hotel',
            'data' => $hotel
        ], 200);
    }
}