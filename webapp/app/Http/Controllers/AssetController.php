<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AssetController extends Controller
{
    public function index(Request $request)
    {
        if ($request->isMethod('post'))
        {
            if ($request->has('url'))
                return shortURL($request->input('url'));
        }

        abort(404);
    }

    public function shortURL(string $url)
    {

    }
}
