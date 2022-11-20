<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Workout extends Model
{
    use HasFactory;
    
    public function WorkoutType(){
        return $this->hasOne(WorkoutType::class, 'id', 'type_id');
    }
    public function workoutUser(){
        return $this->belongsToMany(User::class,'user_workouts')->withPivot('is_liked')->withTimestamps();
    }
    public function getRecommended(){
        return $this->where(['is_recommend'=>1])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getUnRecommended(){
        return $this->where(['is_recommend'=>0])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getWelcomeInfo(){
        return $this->where(['type_id'=>3])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getRecent(){
        return $this->limit(5)->orderBy('id', 'DESC')->get();
    }
    public function getAllWorkout(){
        return $this->orderBy('id', 'DESC')->get();
    }
    public function getWorkoutByCategory($request){
        return $this->where(['type_id'=>$request->type_id])->orderBy('id', 'DESC')->get();
    }
    public function getSearchWorkout($request){
        return $this->where('workout_title','LIKE',"%" .$request->workout_title. "%")->orderBy('id', 'DESC')->get();
    }
    public function getLikeWorkout($user_id){
        return Workout::with("workoutUser")->whereHas('workoutUser',function ($query)use($user_id){
            $query->where('user_id',$user_id);
        })->get(); 
    }
}
