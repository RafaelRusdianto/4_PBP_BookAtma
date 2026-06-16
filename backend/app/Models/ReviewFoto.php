<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ReviewFoto extends Model
{
    protected $table = 'review_foto';
    protected $primaryKey = 'id_review_foto';

    protected $fillable = [
        'id_review',
        'url_foto'
    ];

    public function review()
    {
        return $this->belongsTo(Review::class, 'id_review');
    }
}
