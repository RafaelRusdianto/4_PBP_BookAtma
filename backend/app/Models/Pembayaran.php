<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pembayaran extends Model
{
    protected $table = 'pembayaran';
    protected $primaryKey = 'id_pembayaran';

    protected $fillable = [
        'id_booking',
        'kode_transaksi',
        'metode_pembayaran',
        'jumlah_bayar',
        'status_pembayaran',
        'tgl_pembayaran'
    ];

    public function booking()
    {
        return $this->belongsTo(Booking::class, 'id_booking');
    }

    public function review()
    {
        return $this->hasOne(Review::class, 'id_pembayaran');
    }
}