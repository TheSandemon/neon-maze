$lines = [System.IO.File]::ReadAllLines((Join-Path $PWD "index.html"))
$newLines = @()
$i = 0
while ($i -lt $lines.Count) {
    if ($lines[$i] -match 'function finishSolve\(\) \{') {
        Write-Host "Found finishSolve at line $($i+1)"
        # Skip until we find the closing brace of this function
        $braceCount = 0
        $startLine = $i
        do {
            $ch = $lines[$i]
            for ($c = 0; $c -lt $ch.Length; $c++) {
                if ($ch[$c] -eq '{') { $braceCount++ }
                if ($ch[$c] -eq '}') { $braceCount-- }
            }
            $i++
        } while ($braceCount -gt 0 -and $i -lt $lines.Count)
        Write-Host "Function ends at line $($i)"
        # Insert new function
        $newFn = "function finishSolve() {"
        $newLines += $newFn
        $newLines += "  if (solvePhase === 'idle') return;"
        $newLines += "  animRunning = false;"
        $newLines += "  if (solvePhase !== 'done') {"
        $newLines += "    if (solveMode === 'astar') {"
        $newLines += "      let state = window._solveState;"
        $newLines += "      if (state && !state.done) { while (state.openSet.length > 0) { if (!stepSolveAnim()) break; } }"
        $newLines += "    } else if (solveMode === 'bfs') {"
        $newLines += "      let state = window._bfsState;"
        $newLines += "      if (state && !state.done) { while (state.queue.length > 0) { if (!stepSolveAnimBFS()) break; } }"
        $newLines += "    } else if (solveMode === 'dfs') {"
        $newLines += "      let state = window._dfsState;"
        $newLines += "      if (state && !state.done) { while (state.stack.length > 0) { if (!stepSolveAnimDFS()) break; } }"
        $newLines += "    } else if (solveMode === 'dijkstra') {"
        $newLines += "      let state = window._dijkstraState;"
        $newLines += "      if (state && !state.done) { while (state && !state.done) { if (!stepSolveAnimDijkstra()) break; } }"
        $newLines += "    }"
        $newLines += "    solvePhase = 'done';"
        $newLines += "  }"
        $newLines += "  let elapsed = ((performance.now() - solveStartTime) / 1000).toFixed(2);"
        $newLines += "  document.getElementById('solveTime').textContent = elapsed + 's';"
        $newLines += "  document.getElementById('pathLen').textContent = solutionPath.length > 0 ? solutionPath.length + ' steps' : '\u2014';"
        $newLines += "  draw();"
        $newLines += "}"
    } else {
        $newLines += $lines[$i]
        $i++
    }
}
[System.IO.File]::WriteAllText((Join-Path $PWD "index.html"), ($newLines -join "`n"))
Write-Host "Done. Total lines: $($newLines.Count)"
