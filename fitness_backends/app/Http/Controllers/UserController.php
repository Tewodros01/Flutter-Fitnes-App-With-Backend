<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Auth;
use JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Mail;
use App\Mail\PasswordReset;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function register(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required|exists:users',
            'password' => 'required|string'
        ]);
        if ($validator->fails()) {
            $plainPassword=$request->password;
            $password=bcrypt($request->password);
            $request->request->add(['password' => $password]);
            // create the user account 
            $created=User::create($request->all());
            $request->request->add(['password' => $plainPassword]);
            // login now..
            return $this->login($request); 
        }else{
            return response()->json([
                'success' => false,
                'message' => 'Email Exists',
            ], 401);
        }
       
    }
    public function login(Request $request)
    {
        
        $input = $request->only('email', 'password');
        $jwt_token = null;
        if (!$jwt_token = JWTAuth::attempt($input)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid Email or Password',
            ], 401);
        }
        // get the user 
        $user = Auth::user();
       
        return response()->json([
            'success' => true,
            'token' => $jwt_token,
            'user' => $user
        ]);
    }
    public function logout(Request $request)
    {
        if(!User::checkToken($request)){
            return response()->json([
             'message' => 'Token is required',
             'success' => false,
            ],422);
        }
        
        try {
            JWTAuth::invalidate(JWTAuth::parseToken($request->token));
            return response()->json([
                'success' => true,
                'message' => 'User logged out successfully'
            ]);
        } catch (JWTException $exception) {
            return response()->json([
                'success' => false,
                'message' => 'Sorry, the user cannot be logged out'
            ], 500);
        }
    }

    public function getCurrentUser(Request $request){
       if(!User::checkToken($request)){
           return response()->json([
            'message' => 'Token is required'
           ],422);
       }
        
        $user = JWTAuth::parseToken()->authenticate();
       //add isProfileUpdated....
       $isProfileUpdated=false;
        if($user->isPicUpdated==1 && $user->isEmailUpdated){
            $isProfileUpdated=true;
            
        }
        $user->isProfileUpdated=$isProfileUpdated;

        return $user;
    }

    public function update(Request $request){
        try {
            $data = $request->all();
            $user=$this->getCurrentUser($request);
            if(!$user){
                return response()->json([
                    'success' => false,
                    'message' => 'User is not found'
                ]);
            }
            $validator = Validator::make($request->all(), [
                'email' => 'required|exists:users',
            ]);
            if ($validator->fails()) {
                unset($data['token']);
        
                $updatedUser = User::where('id', $user->id)->update($data);
                $token = JWTAuth::getToken();
                $user = JWTAuth::toUser($token);
               // $user =  User::find($user->id);
            
                return response()->json([
                    'success' => true, 
                    'message' => 'Information has been updated successfully!',
                    "user"=>$user
                ]);
            }else{
                 return response()->json([
                    'success' => false,
                    'message' => 'Email Exists',
                ], 401);
            }    
        }catch (JWTException $exception) {
            return response()->json([
                'success' => "expired",
                'message' => 'Sorry, Token is expired'
            ]);
        }
    }

    public function likeWorkout(Request $request){
        $user=$this->getCurrentUser($request);
            if(!$user){
               return response()->json([
                'success' => false,
            'message' => 'User is not found'
            ]);
           }
        try {
        $user = Auth::user();
        $post_id=$request->post_id;
        $user->userWorkout()->attach($post_id,['is_liked'=>1]);

       return response()->json([
            'success' => true, 
            'message' => 'Video Liked!',
            'user' =>$user
        ]);
    }catch (JWTException $exception) {
            return response()->json([
                'success' => "expired",
                'message' => 'Sorry, Token is expired'
            ]);
        }
    }
    
    public function disLikeWorkout(Request $request){
        $user=$this->getCurrentUser($request);
            if(!$user){
               return response()->json([
                'success' => false,
            'message' => 'User is not found'
            ]);
           }
        try {
        $user = Auth::user();
        $post_id=$request->post_id;
        $user->userWorkout()->detach();

       return response()->json([
            'success' => true, 
            'message' => 'Video Liked!',
            'user' =>$user
        ]);
    }catch (JWTException $exception) {
            return response()->json([
                'success' => "expired",
                'message' => 'Sorry, Token is expired'
            ]);
        }
    }
    public function likeBook(Request $request){
        try {
            $user=$this->getCurrentUser($request);
            if(!$user){
               return response()->json([
                'success' => false,
            'message' => 'User is not found'
            ]);
           }
        $user = Auth::user();
        $post_id=$request->post_id;
        $user->userBook()->attach($post_id,['is_liked'=>1]);

       return response()->json([
            'success' => true, 
            'message' => 'Book Liked!',
            'user' =>$user
        ]);
       }catch (JWTException $exception) {
            return response()->json([
                'success' => "expired",
                'message' => 'Sorry, Token is expired'
            ]);
        }
    }
    public function disLikeBook(Request $request){
        try {
            $user=$this->getCurrentUser($request);
            if(!$user){
               return response()->json([
                'success' => false,
            'message' => 'User is not found'
            ]);
           }
        $user = Auth::user();
        $post_id=$request->post_id;
        $user->userBook()->detach();

       return response()->json([
            'success' => true, 
            'message' => 'Book Liked!',
            'user' =>$user
        ]);
       }catch (JWTException $exception) {
            return response()->json([
                'success' => "expired",
                'message' => 'Sorry, Token is expired'
            ]);
        }
    }
    public function token(){
        $token = JWTAuth::getToken();
        if(!$token){
            throw new BadRequestHtttpException('Token not provided');
        }
        try{
            $token = JWTAuth::refresh($token);
        }catch(TokenInvalidException $e){
            throw new AccessDeniedHttpException('The token is invalid');
        }
        return response()->json([
            'success' => true,
            'token' => $token,
        ]);
    }
    
}


