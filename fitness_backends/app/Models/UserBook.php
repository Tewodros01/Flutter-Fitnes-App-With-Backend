<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserBook extends Model
{
    use HasFactory;
    public function getAllLikeBook($request){
        return $this->select('is_liked')->where(['user_id'=>$request->user_id])->where(['book_id'=>$request->book_id])->first();
    }
    public function getLikeBook($request){
        return $this->select('is_liked')->where(['user_id'=>$request->user_id])->where(['book_id'=>$request->book_id])->first();
    }
}
