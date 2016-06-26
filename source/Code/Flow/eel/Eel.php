<?php
namespace CodeMonitoring\Framework\Parse;

/*
 * Copyright (C) 2016  Daniel Siepmann <coding@daniel-siepmann.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

use TYPO3\Flow\Resource\Resource;
use TYPO3\Eel\Context;
use TYPO3\Eel\CompilingEvaluator;
use TYPO3\Eel\Helper as EelHelper;

/**
 * Attach the trait to parser or importer, to provide configurable eel
 * expressions to determine whether they can parse a given file.
 *
 * TODO: Check whether we have to use ProtectedContext to prevent calls to
 * methods like local copy?
 */
trait EelParsingDetectionTrait
{
    /**
     * @var string
     */
    protected $eelExpression = 'file.fileExtension == "xml" && String.substr(lines[1], 1, 10) == "checkstyle" && String.substr(lines[1], 21, 3) == "2.5"';

    /**
     * Evaluate configured eel expression on file to detect whether it can be
     * processed.
     *
     * @param Resource $file
     *
     * @return bool
     */
    public function canHandle(Resource $file)
    {
        $context = new Context([
            // Provide EelHelper to parsing.
            'String' => new EelHelper\StringHelper,
            // Provide "variables" to parsing.
            'file' => $file,
            'lines' => file($file->createTemporaryLocalCopy(), FILE_IGNORE_NEW_LINES),
        ]);

        return (bool)(new CompilingEvaluator)->evaluate($this->eelExpression, $context);
    }
}
