$content = Get-Content index.html -Raw
$oldFn = @'
function finishSolve() {
  if (solvePhase === 'idle' || solvePhase === 'done') return;
  // Instant complete any solver
  if (solveMode === 'astar') {
    let state = window._solveState;
    if (!state) { solvePhase = 'done'; return; }
    while (state.openSet.length > 0) { if (!stepSolveAnim()) break; }
  } else if (solveMode === 'bfs') {
    let state = window._bfsState;
    if (!state) { solvePhase = 'done'; return; }
    while (state.queue.length > 0) { if (!stepSolveAnimBFS()) break; }
  } else if (solveMode === 'dfs') {
    let state = window._dfsState;
    if (!state) { solvePhase = 'done'; return; }
    while (state.stack.length > 0) { if (!stepSolveAnimDFS()) break; }
  } else if (solveMode === 'dijkstra') {
    let state = window._dijkstraState;
    if (!state) { solvePhase = 'done'; return; }
    while (state && !state.done) { if (!stepSolveAnimDijkstra()) break; }
  }
  solvePhase = 'done';
  let elapsed = ((performance.now() - solveStartTime) / 1000).toFixed(2);
  document.getElementById('solveTime').textContent = elapsed + 's';
  document.getElementById('pathLen').textContent = solutionPath.length > 0 ? solutionPath.length + ' steps' : '—';
  animRunning = false;
  draw();
}
'@
$newFn = @'
function finishSolve() {
  if (solvePhase === 'idle') return;
  animRunning = false;
  if (solvePhase !== 'done') {
    if (solveMode === 'astar') {
      let state = window._solveState;
      if (state && !state.done) { while (state.openSet.length > 0) { if (!stepSolveAnim()) break; } }
    } else if (solveMode === 'bfs') {
      let state = window._bfsState;
      if (state && !state.done) { while (state.queue.length > 0) { if (!stepSolveAnimBFS()) break; } }
    } else if (solveMode === 'dfs') {
      let state = window._dfsState;
      if (state && !state.done) { while (state.stack.length > 0) { if (!stepSolveAnimDFS()) break; } }
    } else if (solveMode === 'dijkstra') {
      let state = window._dijkstraState;
      if (state && !state.done) { while (state && !state.done) { if (!stepSolveAnimDijkstra()) break; } }
    }
    solvePhase = 'done';
  }
  let elapsed = ((performance.now() - solveStartTime) / 1000).toFixed(2);
  document.getElementById('solveTime').textContent = elapsed + 's';
  document.getElementById('pathLen').textContent = solutionPath.length > 0 ? solutionPath.length + ' steps' : '—';
  draw();
}
'@
$newContent = $content.Replace($oldFn, $newFn)
if ($newContent -eq $content) {
    Write-Host "WARNING: No replacement made!"
} else {
    [System.IO.File]::WriteAllText((Join-Path $PWD "index.html"), $newContent)
    Write-Host "Replacement successful"
}
