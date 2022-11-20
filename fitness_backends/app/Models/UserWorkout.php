<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserWorkout extends Model
{
    use HasFactory;
    public function getAllLikeWorkout($request){
        return $this->select('is_liked')->where(['user_id'=>$request->user_id])->where(['workout_id'=>$request->workout_id])->first();
    }
    public function getLikeWorkout($request){
        return $this->select('is_liked')->where(['user_id'=>$request->user_id])->where(['workout_id'=>$request->workout_id])->first();
    }
}
