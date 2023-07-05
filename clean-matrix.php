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
 * Reset script for Communications API.
 *
 * @package    core
 * @copyright  2023 Andrew Lyons <andrew@nicols.co.uk>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

define('CLI_SCRIPT', true);
require_once('config.php');

$tables = [
    'communication',
    'communication_user',
    'matrix_rooms',
];

mtrace("Resetting all configured communication settings");
foreach ($tables as $tablename) {
    echo "Resetting table ${tablename}: ";
    if (!$DB->get_manager()->table_exists($tablename)) {
        echo "table not found - skipping.\n";
        continue;
    }
    $DB->delete_records($tablename);
    echo "done.\n";
}
