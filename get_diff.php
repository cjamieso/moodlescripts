<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.


/**
 * This file diffs the last commit and determines which set of tests should run.
 *
 * @package    moodlescripts
 * @category   moodle
 * @copyright  2016 Craig Jamieson
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

exec('git diff --name-only HEAD HEAD~1', $files);
$paths = array();

foreach ($files as $file) {
    if (dirname($file) != '.') {
        $pieces = explode('/', dirname($file));
        if (isset($pieces[0])) {
            // Paths: 'report', 'blocks', and 'mod' have two portions.
            if ($pieces[0] == 'report' || $pieces[0] == 'blocks' || $pieces[0] == 'mod') {
                if (isset($pieces[1])) {
                    $paths[] = $pieces[0] . '/' . $pieces[1];
                }
            // Path 'course' requires 3 parts, /course/format/xxxx
            } else if ($pieces[0] == 'course') {
                if (isset($pieces[1]) && isset($pieces[2])) {
                    $paths[] = $pieces[0] . '/' . $pieces[1] . '/' . $pieces[2];
                }
            }
        }

    }
}

$file = fopen("paths.txt", "w");

$paths = array_unique($paths);
foreach ($paths as $path) {
    switch ($path) {
        case 'report/analytics':
            fwrite($file, "analytics\n");
            break;
        case 'blocks/course_message':
            fwrite($file, "mail\n");
            break;
        case 'blocks/skills_group':
            fwrite($file, "sg\n");
            break;
        case 'blocks/nurs_navigation':
            fwrite($file, "nn\n");
            break;
        case 'course/format/collblct':
            exec('ls');
            break;
        default:
            // Do nothing.
    }
}

print_r($paths);

fclose($file);