<?php

namespace App\Http\Controllers;

use App\Models\Workout;
use Illuminate\Http\Request;

class WorkoutController extends Controller
{
    public function getAllWorkout(){
        $list = new Workout();
        $list = $list->getAllWorkout();
        foreach($list as $item){
            $item['workout_content']=strip_tags($item['workout_content']);
            $item['workout_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['workout_content']);
        }
        return response()->json($list);
    }
    public function getWorkoutByCategory(Request $request){
        $list = new Workout();
        $list = $list->getWorkoutByCategory($request);
        foreach($list as $item){
            $item['workout_content']=strip_tags($item['workout_content']);
            $item['workout_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['workout_content']);
        }
        return response()->json($list);
    }
    public function getAllSearchWorkout(Request $request){
        $list = new Workout();
        $list = $list->getSearchWorkout($request);
        foreach($list as $item){
            $item['workout_content']=strip_tags($item['workout_content']);
            $item['workout_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['workout_content']);
        }
        return response()->json($list);
    }
    public function getAllLikeWorkout(Request $request){
        $user_id = $request->user_id;
        $list = new Workout();
        $list = $list->getLikeWorkout($user_id);
        foreach($list as $item){
            $item['workout_content']=strip_tags($item['workout_content']);
            $item['workout_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['workout_content']);
        }
        return response()->json($list);
    }
}
