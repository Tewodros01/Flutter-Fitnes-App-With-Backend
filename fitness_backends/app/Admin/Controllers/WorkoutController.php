<?php

namespace App\Admin\Controllers;

use App\Models\Workout;
use App\Models\WorkoutType;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class WorkoutController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Workout';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Workout());
        $grid->workout_author();
        $grid->workout_title();
        $grid->column('WorkoutType.title','Category');
        $grid->workout_description();
        $grid->workout_content();
        $grid->column('is_recommend','Recommended')->bool();
        $grid->column('workout_thumbnail',_('Thumbnail'))->image('','60','60');


        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(Workout::findOrFail($id));



        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Workout());
        $form->select('type_id',_('Category'))->options((new WorkoutType())::selectOptions());
        $form->text('workout_title',_('Title'));
        $form->text('workout_author',_('Author'));
        $form->text('workout_description',_('Description'))->required();
        $form->image('workout_thumbnail',_('Thumbnail'));
        $form->file('workout_content',_('Workout'));
        $state = [
            'on' => ['value' => 1, 'text' => 'Publish'],
            'off' => ['value' => 0, 'text' => 'Draft']
        ];
        $form->switch('is_recommend',_('Publish'))->states($state);


        return $form;
    }
}
