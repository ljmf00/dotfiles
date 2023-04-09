<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class Asset extends Model
{
    use HasUuids;

    // key settings
    public $incrementing = false;
    protected $keyType = 'string';

    // metadata
    public $timestamps = false;

    public function newUniqueId(): string
    {
        return (string) Str::random(9);
    }

    public function uniqueIds(): array
    {
        return ['id'];
    }
}
