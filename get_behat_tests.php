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
 * This file loads the behat.yml files to see which tests were run.
 *
 * @package    moodlescripts
 * @category   moodle
 * @copyright  2017 Craig Jamieson
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

$path = $argv[1];
$fromrun = $argv[2];
$torun = $argv[3];
$exitcode = intval($argv[4]);
if (!is_numeric($fromrun) || !is_numeric($torun)) {
    echo 'invalid argument for fromrun or torun';
}

$processcounter = 0;
for ($i = $fromrun; $i <= $torun; $i++) {
    $filepath = "{$path}{$i}/behat/behat.yml";
    if (file_exists($filepath)) {
        $contents = file_get_contents($filepath);
        preg_match('/paths:(.*?)contexts:/s', $contents, $match);
        echo 'For run: ', $i;
        $stripped = substr($match[0], strlen("paths:"), -strlen("contexts:"));
        echo $stripped, "\n";
        if (trim($stripped) == "null") {
            echo "found empty run, adjusting exit code\n";
            $exitcode ^= (1 << $processcounter);
        }
    } else {
        echo 'file not valid for run: ', $i;
    }
    $processcounter++;
}

if ($exitcode != 0) {
    $file = fopen("rerun.txt", "w");
    $processcounter = 0;
    for ($i = $fromrun; $i <= $torun; $i++) {
        if (($exitcode & (1 << $processcounter)) != 0) {
            fwrite($file, "$i\n");
        }
        $processcounter++;
    }
    fclose($file);
}
exit($exitcode);
