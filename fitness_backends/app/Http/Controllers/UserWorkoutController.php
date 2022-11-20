<?php

namespace App\Http\Controllers;

use App\Models\UserWorkout;
use Illuminate\Http\Request;

class UserWorkoutController extends Controller
{
    
    public function getLikeWorkout(Request $request){
        $list = new UserWorkout();
        $list = $list->getAllLikeWorkout($request);
        if (!empty($list)) {
            $liked = $list->is_liked;
            return response()->json([
             'is_liked' => $liked,
             'message' => 'User liked video'
           ]);
        }
         else{
             return response()->json([
                 'is_liked' => 0,
                 'message' => 'User Not liked video'
             ]);
          }
    }
   
}
