<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetailBooking extends Model
{
    protected $table = 'detail_booking';
    protected $primaryKey = 'id_detail_booking';

    protected $fillable = [
        'id_kamar',
        'id_booking',
        'harga_per_malam',
        'jumlah_malam',
        'subtotal'
    ];

    public function booking()
    {
        return $this->belongsTo(Booking::class, 'id_booking');
    }

    public function kamar()
    {
        return $this->belongsTo(Kamar::class, 'id_kamar');
    }
}