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
 * Run the code checker on the list of changed files.
 *
 * @package    moodlescripts
 * @copyright  2016 Craig Jamieson
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

define('CLI_SCRIPT', true);
$ignorenames = array('jquery.multiple.select.js');
$ignoretypes = array('feature', 'png', 'PNG', 'xml', 'svg', 'txt', 'md');

require(dirname(__FILE__) . '/../config.php');
require_once($CFG->libdir . '/clilib.php');
require_once($CFG->dirroot . '/local/codechecker/locallib.php');

chdir('../');
exec('git diff-tree --no-commit-id --name-only -r HEAD', $files);
chdir('local/codechecker');

$keep = array();
foreach ($files as $file) {
    // File may have been deleted.
    if (file_exists($CFG->dirroot . '/' . $file)) {
        $pathparts = pathinfo($file);
        // This skips any folders that might exist.
        if (isset($pathparts['extension'])) {
            if (array_search($pathparts['extension'], $ignoretypes) === false) {
                $filename = $pathparts['filename'] . $pathparts['extension'];
                if (array_search($filename, $ignorenames) === false) {
                    $keep[] = local_codechecker_clean_path($CFG->dirroot . '/' . trim($file, '/'));
                }
            }
        }
    }
}

if (count($keep) == 0) {
    return 0;
}
raise_memory_limit(MEMORY_HUGE);

$standard = $CFG->dirroot . str_replace('/', DIRECTORY_SEPARATOR, '/local/codechecker/moodle');
$sniffer = new PHP_CodeSniffer(1, 0, 'utf-8', false);
$cli = new local_codechecker_codesniffer_cli();
$sniffer->setCli($cli);
$sniffer->setIgnorePatterns(local_codesniffer_get_ignores());
$sniffer->process($keep, local_codechecker_clean_path($standard));
$results = $sniffer->reporting->printReport('full', false, $cli->getCommandLineValues(), null);
return $results['errors'] > 0 ? 1 : 0;