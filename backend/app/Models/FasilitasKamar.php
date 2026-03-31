<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FasilitasKamar extends Model
{
    protected $table = 'fasilitas_kamar';
    public $timestamps = true;

    protected $fillable = [
        'id_kamar',
        'id_fasilitas'
    ];
}