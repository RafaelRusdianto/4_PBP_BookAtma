<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KamarFoto extends Model
{
    protected $table = 'kamar_foto';
    protected $primaryKey = 'id_kamar_foto';

    protected $fillable = [
        'id_kamar',
        'url_foto'
    ];

    public function kamar()
    {
        return $this->belongsTo(Kamar::class, 'id_kamar');
    }
}