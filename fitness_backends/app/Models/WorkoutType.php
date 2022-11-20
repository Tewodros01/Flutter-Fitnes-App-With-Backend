<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Encore\Admin\Traits\DefaultDatetimeFormat;
use Encore\Admin\Traits\ModelTree;

class WorkoutType extends Model
{
    use HasFactory;
    use DefaultDatetimeFormat;
    use ModelTree;
    
    public function getList(){
        return $this->get();
    }
}
