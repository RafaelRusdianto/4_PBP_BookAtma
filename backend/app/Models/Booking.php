<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $table = 'booking';
    protected $primaryKey = 'id_booking';

    protected $fillable = [
        'id_user',
        'tgl_booking',
        'check_in',
        'check_out',
        'total_harga',
        'status'
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function detailBooking()
    {
        return $this->hasMany(DetailBooking::class, 'id_booking');
    }

    public function pembayaran()
    {
        return $this->hasOne(Pembayaran::class, 'id_booking');
    }
}