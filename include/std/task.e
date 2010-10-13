namespace task

--****
-- == Multi-tasking
--
-- <<LEVELTOC level=2 depth=4>>
--
-- === General Notes
--
-- For a complete overview of the task system, please see the mini-guide 
-- [[:Multitasking in Euphoria]].
-- 
-- === Warning
-- 
-- The task system does not yet function in a shared library. Task routine
-- calls that are compiled into a shared library are emitted as a NOP (no
-- operation) and will therefore have no effect.
-- 
-- It is planned to allow the task system to function in shared libraries
-- in future versions of OpenEuphoria.
-- 
-- === Routines

constant M_SLEEP = 64

--**
-- Suspends a task for a short period, allowing other tasks to run in the meantime.
--
-- Parameters:
--		# ##delaytime## : an atom, the duration of the delay in seconds.
--
-- Comments:
--
-- This procedure is similar to [[:sleep]](), but allows for other tasks to run by yielding on a regular basis.
-- Like [[:sleep]](), its argument needs not being an integer.
--
-- See Also:
-- [[:sleep]]

public procedure task_delay(atom delaytime)
	atom t
	t = time()

	while time() - t < delaytime do
		machine_proc(M_SLEEP, 0.01)
		task_yield()
	end while
end procedure

--****
-- Signature:
-- <built-in> procedure task_clock_start()
--
-- Description: 
-- Restart the clock used for scheduling real-time tasks. 
--
-- Comments:
--
-- Call this routine, some time after calling task_clock_stop(), when you want scheduling of real-time tasks to continue.
--
-- [[:task_clock_stop]]() and ##task_clock_start##() can be used to freeze the scheduling of real-time tasks.
--
-- ##task_clock_start##() causes the scheduled times of all real-time tasks to be incremented by 
-- the amount of time since [[:task_clock_stop]]() was called. This allows a game, 
-- simulation, or other program to continue smoothly.
-- 
-- Time-shared tasks are not affected. 
--  
-- Example 1:
-- <eucode>
--  -- freeze the game while the player answers the phone
-- task_clock_stop()
-- while get_key() = -1 do
-- end while
-- task_clock_start()
-- </eucode>
--
-- See Also: 
--  [[:task_clock_stop]], [[:task_schedule]], [[:task_yield]], [[:task_suspend]], 
-- [[:task_delay]]
--

--****
-- Signature:
-- <built-in> procedure task_clock_stop()
--
-- Description: 
-- Stop the scheduling of real-time tasks.
--
-- Comments:
--
-- Call ##task_clock_stop##() when you want to take time out from scheduling real-time tasks.
-- For instance, you want to temporarily suspend a game or simulation for a period of time.
--
-- Scheduling will resume when [[:task_clock_start]]() is called.
--
-- Time-shared tasks can continue. The current task can also continue, unless it's a real-time task and it yields.
-- 
-- The [[:time]]() function is not affected by this.
--  
-- See Also: 
--  [[:task_clock_start]], [[:task_schedule]], [[:task_yield]], [[:task_suspend]], 
-- [[:task_delay]]
--

--****
-- Signature:
-- <built-in> function task_create(integer rid, sequence args)
--
-- Description: 
-- Create a new task, given a home procedure and the arguments passed to it.
--
-- Parameters:
-- 		# ##rid## : an integer, the routine_id of a user-defined Euphoria procedure.
-- 		# ##args## : a sequence, the list of arguments that will be passed to this procedure when the task starts executing.
--
-- Returns:
-- An **atom**, a task identifier, created by the system. It can be used to identify this task to the other Euphoria multitasking routines.
--
-- Errors:
-- There must be at most 12 parameters in ##args##.
--
-- Comments:
--
-- ##task_create##() creates a new task, but does not start it executing. You must call [[:task_schedule]]() for this purpose.
--
-- Each task has its own set of private variables and its own call stack. Global and local variables are shared between all tasks.
--
-- If a run-time error is detected, the traceback will include information on all tasks, with the offending task listed first.
--
-- Many tasks can be created that all run the same procedure, possibly with different parameters.
--
-- A task cannot be based on a function, since there would be no way of using the function result.
--
-- Each task id is unique. ##task_create##() never returns the same task id as it did before.
-- Task id's are integer-valued atoms and can be as large as the largest integer-valued atom (15 digits).
--  
-- Example 1:
-- <eucode>
--  mytask = task_create(routine_id("myproc"), {5, 9, "ABC"})
-- </eucode>
--  
-- See Also: 
--   [[:task_schedule]], [[:task_yield]], [[:task_suspend]], [[:task_self]]
--

--****
-- Signature:
-- <built-in> function task_list()
--
-- Description: 
-- Get a sequence containing the task id's for all active or suspended tasks.
--
-- Returns:
-- A **sequence**, of atoms, the list of all task that are or may be scheduled.
--
-- Comments: 
--
-- This function lets you find out which tasks currently exist. Tasks that have terminated are not included. 
-- You can pass a task id to [[:task_status]]() to find out more about a particular task.
--
-- Example 1:
-- <eucode>
--  sequence tasks
--
-- tasks = task_list()
-- for i = 1 to length(tasks) do
--     if task_status(tasks[i]) > 0 then
--         printf(1, "task %d is active\n", tasks[i])
--     end if
-- end for
-- </eucode>
--
-- See Also: 
-- [[:task_status]], [[:task_create]], [[:task_schedule]], [[:task_yield]], [[:task_suspend]]
--

--****
-- Signature:
-- <built-in> procedure task_schedule(atom task_id, object schedule)
--
-- Description: 
-- Schedule a task to run using a scheduling parameter. 
--
-- Parameters:
--		# ##task_id## : an atom, the identifier of a task that did not terminate yet.
--		# ##schedule## : an object, describing when and how often to run the task.
--
-- Comments:
--
-- ##task_id## must have been returned by [[:task_create]]().
--
-- The task scheduler, which is built-in to the Euphoria run-time system, 
-- will use ##schedule## 
-- as a guide when scheduling this task. It may not always be possible to achieve the desired 
-- number of consecutive runs, or the desired time frame. For instance, a task might take so 
-- long before yielding control, that another task misses its desired time window.
--
-- ##schedule## is being interpreted as follows:
--
-- ##schedule## is an integer:
--
-- This defines ##task_id## as time shared, and tells the task scheduler how many times it
-- should the task in one burst before it considers running other tasks. ##schedule## must be greater than zero then.
--
-- Increasing this count will increase the percentage of CPU time given to the selected task,
-- while decreasing the percentage given to other time-shared tasks. Use trial and error to find the optimal trade off. 
-- It will also increase the efficiency of the program, since each actual task switch wastes a bit of time.
--
-- ##schedule## is a sequence:
-- 
-- In this case, it must be a pair of positive atoms, the first one not being less than the second one.
-- This defines ##task_id## as a real time task.
-- The pair states the minimum and maximum times, in seconds, to wait before running the task. 
-- The pair also sets the time interval for subsequent runs of the task, until the next call to ##task_schedule##() or [[:task_suspend]]().
--
-- Real-time tasks have a higher priority. Time-shared tasks are run when no real-time task is ready to execute.
--
-- ----
--
-- A task can switch back and forth between real-time and time-shared. It all depends on the last call to ##task_schedule##() for that task. 
-- The scheduler never runs a real-time task before the start of its time frame (min value in the ##{min, max}## pair),
-- and it tries to avoid missing the task's deadline (max value).
--
-- For precise timing, you can specify the same value for min and max. However, by specifying a range of times,
-- you give the scheduler some flexibility. This allows it to schedule tasks more efficiently, 
-- and avoid non-productive delays. 
-- When the scheduler must delay, it calls [[:sleep]](), unless the required delay is very short. 
-- [[:sleep]]() lets the operating system run other programs.
--
-- The min and max values can be fractional. If the min value is smaller than the resolution of the scheduler's clock 
-- (currently 0.01 seconds on //Windows// or // Unix//) then accurate time scheduling cannot be performed, but the 
-- scheduler will try to run the task several times in a row to approximate what is desired.
--
-- For example, if you ask for a min time of 0.002 seconds, then the scheduler will try to run your task 
-- .01/.002 = 5 times in a row before waiting for the clock to "click" ahead by .01. 
-- During the next 0.01 seconds it will run your task (up to) another 5 times etc. provided 
-- your task can be completed 5 times in one clock period.
-- 
-- At program start-up there is a single task running. Its task id is 0, and initially it's a time-shared task
-- allowed 1 run per [[:task_yield]](). No other task can run until task 0 executes a [[:task_yield]]().
--
-- If task 0 (top-level) runs off the end of the main file, the whole program terminates, 
-- regardless of what other tasks may still be active.
--
-- If the scheduler finds that no task is active, i.e. no task will ever run again (not even task 0), 
-- it terminates the program with a 0 exit code, similar to [[:abort]](0).
--  
-- Example 1:
-- <eucode>
-- -- Task t1 will be executed up to 10 times in a row before
-- -- other time-shared tasks are given control. If a real-time
-- -- task needs control, t1 will lose control to the real-time task.
-- task_schedule(t1, 10)
--
-- -- Task t2 will be scheduled to run some time between 4 and 5 seconds
-- -- from now. Barring any rescheduling of t2, it will continue to
-- -- execute every 4 to 5 seconds thereafter.
-- task_schedule(t2, {4, 5})
-- </eucode>
--  
-- See Also: 
--   [[:task_create]], [[:task_yield]], [[:task_suspend]]
--

--****
-- Signature:
-- <built-in> function task_self()
--
-- Description: 
-- Return the task id of the current task.
--
-- Comments: 
--
-- This value may be needed, if a task wants to schedule or suspend itself.
--
-- Example 1:
-- <eucode>
--  -- schedule self
-- task_schedule(task_self(), {5.9, 6.0})
-- </eucode>
--  
-- See Also: 
-- [[:task_create]], [[:task_schedule]], [[:task_yield]], [[:task_suspend]]
--

--****
-- Signature:
-- <built-in> function task_status(atom task_id)
--
-- Description: 
-- Return the status of a task.
--
-- Parameters:
-- 		# ##task_id## : an atom, the id of the task being queried.
--
-- Returns:
-- An **integer**,
-- * -1 ~-- task does not exist, or terminated
-- * 0 ~-- task is suspended
-- * 1 ~-- task is active
--
-- Comments:
--
-- A task might want to know the status of one or more other tasks when deciding whether to proceed with some processing.
--
-- Example 1:
-- <eucode>
--  integer s
--
-- s = task_status(tid)
-- if s = 1 then
--     puts(1, "ACTIVE\n")
-- elsif s = 0 then
--     puts(1, "SUSPENDED\n")
-- else
--     puts(1, "DOESN'T EXIST\n")
-- end if
-- </eucode>
--
-- See Also: 
--  [[:task_list]], [[:task_create]], [[:task_schedule]], [[:task_suspend]]
--

--****
-- Signature:
-- <built-in> procedure task_suspend(atom task_id)
--
-- Description: 
-- Suspend execution of a task.
--
-- Parameters:
-- 		# ##task_id## : an atom, the id of the task to suspend.
--
-- Comments:
--
-- A suspended task will not be executed again unless there is a call to [[:task_schedule]]() for the task.
--
-- ##task_id## is a task id returned from [[:task_create]]().
---
-- Any task can suspend any other task. If a task suspends itself, the suspension will start as soon as the task calls [[:task_yield]]().
--
-- Suspending a task and never scheduling it again is how to kill a task. There is no 
-- task_kill() primitives because undead tasks were creating too much trouble and confusion.
-- As a general fact, nothing that impacts a running task can be effective as long as the task has not yielded.
--
-- Example 1:
-- <eucode>
--  -- suspend task 15
-- task_suspend(15)
--
-- -- suspend current task
-- task_suspend(task_self())
-- </eucode>
--
-- See Also: 
--   [[:task_create]], [[:task_schedule]], [[:task_self]], [[:task_yield]]
--

--****
-- Signature:
-- <built-in> procedure task_yield()
--
-- Description: 
-- Yield control to the scheduler. The scheduler can then choose another task to run, or 
-- perhaps let the current task continue running.
--
-- Comments: 
-- 
-- Tasks should call ##task_yield##() periodically so other tasks will have a chance to run. 
-- Only when ##task_yield##() is called, is there a way for the scheduler to take back control 
-- from a task. This is what's known as cooperative multitasking.
--
-- A task can have calls to ##task_yield##() in many different places in its code, and at any depth of subroutine call.
--
-- The scheduler will use the current scheduling parameter (see [[:task_schedule]]), 
-- in determining when to return to the current task.
--
-- When control returns, execution will continue with the statement that follows ##task_yield##().
-- The call-stack and all private variables will remain as they were when ##task_yield##() was called. 
-- Global and local variables may have changed, due to the execution of other tasks.
--
-- Tasks should try to call ##task_yield##() often enough to avoid causing real-time tasks to miss their time window, 
-- and to avoid blocking time-shared tasks for an excessive period of time. On the other hand,
-- there is a bit of overhead in calling ##task_yield##(), and this overhead is slightly larger 
-- when an actual switch to a different task takes place.
-- A ##task_yield##() where the same task continues executing takes less time.
--
-- A task should avoid calling ##task_yield##() when it is in the middle of a delicate operation 
-- that requires exclusive access to some data. Otherwise a race condition could occur, where 
-- one task might interfere with an operation being carried out by another task.
-- In some cases a task might need to mark some data as "locked" or "unlocked" in order to prevent this possibility.
-- With cooperative multitasking, these concurrency issues are much less of a problem than with
-- the preemptive multitasking that other languages support.
--  
-- Example 1:
-- <eucode>
--  -- From Language war game.
-- -- This small task deducts life support energy from either the
-- -- large Euphoria ship or the small shuttle.
-- -- It seems to run "forever" in an infinite loop, 
-- -- but it's actually a real-time task that is called
-- -- every 1.7 to 1.8 seconds throughout the game.
-- -- It deducts either 3 units or 13 units of life support energy each time.
-- 
-- procedure task_life()
-- -- independent task: subtract life support energy 
--     while TRUE do
--         if shuttle then
--             p_energy(-3)
--         else
--             p_energy(-13)
--         end if
--         task_yield()
--     end while
-- end procedure
-- </eucode>
--
-- See Also: 
-- [[:task_create]], [[:task_schedule]], [[:task_suspend]]
