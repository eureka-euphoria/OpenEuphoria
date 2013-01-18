-- (c) Copyright - See License.txt

ifdef ETYPE_CHECK then
	with type_check
elsedef
	without type_check
end ifdef

include std/filesys.e
include std/locale.e
include std/text.e

include common.e

export enum
	MISSING_CMD_PARAMETER = 353,
	MSG_CC_PREFIX = 600,
	NONSTANDARD_LIBRARY,
	DUPLICATE_MULTI_ASSIGN,
	TRACE_LINES_CMD,
	BAD_TRACE_LINES,
	BUILDDIR_IS_FILE,
	BUILDDIR_IS_UNDEFINED,
	$

-- don't change this please, but please look for -deleted- items before adding new options
-- to the bottom of this list. Re-use -deleted- items.
constant StdErrMsgs = {
	{  0, "Unknown message code: [1]"},
	{  1, "[1] is missing defined word before 'or'"},
	{  2, "[1] is missing defined word before 'and'"},
	{  3, "[1] word must be an identifier"},
	{  4, "[1] not understood"},
	{  5, "[1] is not supported in Euphoria for [2]"},
	{  6, "[1] is missing defined word before 'then'"},
	{  7, "[1] duplicate 'not'"},
	{  8, "[1] 'then' follows '[2]'"},
	{  9, "[1] 'or' follows '[2]'"},
	{ 10, "[1] 'and' follows '[2]'"},
	{ 11, "[1] 'then' follows 'not'"},
	{ 12, "[1] conflicts with a file name used internally by the Translator"},
	{ 13, "'with fallthru' is only valid in a switch statement"},
	{ 14, "'with entry' is only valid on a while or loop statement"},
	{ 15, "'without fallthru' is only valid in a switch statement"},
	{ 16, "'public' or 'export' must be followed by:\n<a type>, 'constant', 'enum', 'procedure', 'type' or 'function'"},
	{ 17, "'end' has no matching '[1]'"},
	{ 18, "'global' must be followed by:\n<a type>, 'constant', 'enum', 'procedure', 'type' or 'function'"},
	{ 19, "'[1]' has not been declared"},
	{ 20, "'[1]' needs [2] argument"},
	{ 21, "'$' must only appear between '[[]' and ']' or as the last item in a sequence literal."},
	{ 22, "a fallthru must be inside a switch"},
	{ 23, "A namespace qualifier is needed to resolve '[1]'\nbecause '[2]' is declared as a global/public symbol in:\n[3]"},
	{ 24, "a variable name is expected here"},
	{ 25, "found ... [1] ... but was expecting an identifier name"},
	{ 26, "Argument [1] of [2] ([3]) was omitted, but there is no default value defined"},
	{ 27, "An unknown 'with/without' option has been specified"},
	{ 28, "a loop variable name is expected here"},
	{ 29, "Argument [1] was omitted but there is no default value defined"},
	{ 30, "An enum constant must be an integer"},
	{ 31, "attempt to redefine [1]."},
	{ 32, "an identifier is expected here"},
	{ 33, "a case block cannot follow a case else block"},
	{ 34, "a case must be inside a switch"},
	{ 35, "A label clause must be followed by a constant string"},
	{ 36, "a new namespace identifier is expected here"},
	{ 37, "a type is expected here"},
	{ 38, "A label clause must be followed by a literal string"},
	{ 39, "break must be inside an if block "},
	{ 40, "break statement must be inside a if or a switch block"},
	{ 41, "badly-formed list of parameters - expected ',' or ')'"},
	{ 42, "Block comment from line [1] not terminated."},
	{ 43, "Compiler is unknown"},
	{ 44, "case else cannot be first case in switch"},
	{ 45, "Couldn't open [1][2] for writing"},
	{ 46, "cannot build a dll for DOS"},
	{ 47, "Can't open main-.h file for output\n"},
	{ 48, "Cannot use the filename, [1], under DOS.\nUse the Windows version with -plat DOS instead.\n"},
	{ 49, "continue statement must be inside a loop"},
	{ 50, "continue must be inside a loop"},
	{ 51, "Can't open '[1]'"},
	{ 52, "can't find '[1]' in any of ...\n[2]"},
	{ 53, "Can't open init-.c for append\n"},
	{ 54, "Can't open main-.c for output\n"},
	{ 55, "Can't open init-.c for output\n"},
	{ 56, "character constant is missing a closing '"},
	{ 57, "Couldn't open .c file for output"},
	{ 58, "DJGPP option only available for DOS."},
	{ 59, "Duplicate label name"},
	{ 60, "DJGPP environment variable is not set"},
	{ 61, "defined word must only have alphanumerics and underscore"},
	{ 62, "digit '[1]' at position [2] is outside of number base"},
	{ 63, "duplicate case value used."},
	{ 64, "duplicate entry clause in a loop header"},
	{ 65, "End of file reached while searching for 'end ifdef' to match 'ifdef' on line [1]"},
	{ 66, "expected 'then' or ',', not [1]"},
	{ 67, `end of line reached with no closing "`},
	{ 68, "expected [1], not [2]"},
	{ 69, "expected ',' or ')'"},
	{ 70, "enum constants must be assigned an integer"},
	{ 71, "expected an atom, string or a constant assigned an atom or a string"},
	{ 72, "entry must be inside a loop"},
	{ 73, "entry statement is being used without a corresponding entry clause in the loop header"},
	{ 74, "Errors resolving the following references:\n[1]"},
	{ 75, "Expecting 'end ifdef' to match 'ifdef' on line [1]"},
	{ 76, "expected to see an assignment after '[1]', such as =, +=, -=, *=, /= or &="},
	{ 77, "Expecting 'then' on 'elsifdef' line"},
	{ 78, "Expecting a 'word' to follow 'elsifdef'"},
	{ 79, "Expected end of [1] block, not [2]"},
	{ 80, "entry keyword is not supported inside an if or switch block header"},
	{ 81, "Expecting to find a word to define but reached end of line first."},
	{ 82, "expecting possibly 'then' not end of line"},
	{ 83, "entry is not supported in for loops"},
	{ 84, "enum constants must be integers"},
	{ 85, "expected to see a parameter declaration, not ')'"},
	{ 86, "exponent not formed correctly"},
	{ 87, "exit/break argument out of range"},
	{ 88, "exit statement must be inside a loop"},
	{ 89, "exit must be inside a loop"},
	{ 90, "found [1] '[2]' but was expecting a parameter name instead."},
	{ 91, "found [1] but expected 'else', an atom, string, constant or enum"},
	{ 92, "found [1] but was expecting a parameter name instead."},
	{ 93, "-deleted-"},
	{ 94, "fractional part of number is missing"},
	{ 95, "file name is missing"},
	{ 96, "Goto statement without a string label."},
	{ 97, "hex number not formed correctly"},
	{ 98, "internal nested call parsing error"},
	{ 99, "integer or constant expected"},
	{100, "expecting 'as' or end-of line. Unexpected text on 'include' directive"},
	{101, "illegal character in source"},
	{102, "illegal character"},
	{103, "illegal character (ASCII 0) at line:col [1]:[2]"},
	{104, "includes are nested too deeply"},
	{105, "Invalid number base specifier '[1]'"},
	{106, "internal: deref problem"},
	{107, "leaving too many blocks [1] > [2]"},
	{108, "Mismatched 'else'. Should this be an 'elsedef' to match 'ifdef' on line [1]"},
	{109, "may not assign to a for-loop variable"},
	{110, "may not change the value of a constant"},
	{111, "Mismatched 'end if'. Should this be an 'end ifdef' to match 'ifdef' on line [1]"},
	{112, "Multitasking operations are not supported in a .dll or .so"},
	{113, "missing namespace qualifier"},
	{114, "missing default namespace qualifier"},
	{115, "missing closing quote on file name"},
	{116, "Not expecting anything on same line as 'elsdef'"},
	{117, "Not expecting to see '[1]' here"},
	{118, "Not expecting 'else'"},
	{119, "Not expecting 'elsif'"},
	{120, "no value returned from function"},
	{121, "number not formed correctly"},
	{122, "no 'word' was found following [1]"},
	{123, "out of memory - turn off trace and profile"},
	{124, "only one decimal point allowed"},
	{125, "Only integer literals can use the '0[1]' format"},
	{126, "program includes too many files"},
	{127, "Punctuation missing in between number and '[1]'"},
	{128, "retry must be inside a loop"},
	{129, "Raw string literal from line [1] not terminated."},
	{130, "return must be inside a procedure or function"},
	{131, "retry statement must be inside a loop"},
	{132, "Syntax error - expected to see possibly [1], not [2]"},
	{133, "Syntax error - Unknown namespace '[1]' used"},
	{134, "Should this be 'elsedef' for the ifdef on line [1]?"},
	{135, "Syntax error - expected to see an expression, not [1]"},
	{136, "sample size must be a positive integer"},
	{137, "single-quote character is empty"},
	{138, "Syntax error - expected to see [1] after [2], not [3]"},
	{139, "Should this be 'elsifdef' for the ifdef on line [1]?"},
	{140, "Sorry, too many .c files with the same base name"},
	{141, "the entry statement must appear at most once inside a loop"},
	{142, "the entry statement can not be used in a 'for' block"},
	{143, "the innermost block containing an entry statement must be the loop it defines an entry in."},
	{144, "the entry statement must appear inside a loop"},
	{145, """tab character found in string - use \t instead"""},
	{146, "Type Check Error when inlining literal"},
	{147, "too many warning errors"},
	{148, "types must have exactly one parameter"},
	{149, "type must return true / false value"},
	{150, "Unknown compiler"},
	{151, "Unknown build file type"},
	{152, "Unknown block label"},
	{153, "Unknown namespace \"[1]\" in default argument"},
	{154, "unknown with/without option '[1]'"},
	{155, "unknown escape character"},
	{156, "Unknown label '[1]'"},
	{157, "Variable [1] has not been declared"},
	{158, "Wrong number of arguments supplied for forward reference\n\t[1] ([2]): [3] [4].  Expected [5], but found [6]."},
	{159, "WATCOM environment variable is not set"},
	{160, "warning names must be enclosed in '(' ')'"},
	{161, "#! may only be on the first line of a program"},
	{162, "-deleted-"},
	{163, "Compiling [1:3.0]% [2]"},
	{164, "Couldn't compile file '[1]'"},
	{165, "Status: [1] Command: [2]"},
	{166, "Linking 100% [1]"},
	{167, "Unknown compiler type: [1]"},
	{168, "Unable to link [1]"},
	{169, "Status: [1] Command: [2]"},
	{170, "\n[1].c files were created."},
	{171, "Link resource file into resulting executable"},
	{172, "To build your project, type [1][2].mak"},
	{173, "To build your project, include [1].mak into a larger Makefile project"},
	{174, "To build your project, change directory to [1] and type [2][3].mak"},
	{175, "\nTo run your project, type [1]"},
	{176, "Compiling with [1]"},
	{177, "Do not display status messages" },
	{178, "Set the compiler to Watcom"},
	{179, "Set the compiler to DJGPP"},
	{180, "Set the compiler to GCC" },
	{181, "Set the compiler directory"},
	{182, "Create a console application"},
	{183, "Create a shared library"},
	{184, "Create a shared library"},
	{185, "Set the platform for the translated code"},
	{186, "Use a non-standard library"},
	{187, "Unable to link resource file [1] into executable [2]"},
	{188, "Set the stack size (Watcom)"},
	{189, "Enable debug mode for generated code"},
	{190, "Set the number of C statements per generated file before splitting."},
	{191, "Keep the generated files"},
	{192, "Generate a partial project Makefile"},
	{193, "Generate a full Makefile"},
	{194, "Could not remove directory [1]"},
	{195, "-deleted-"},
	{196, "Do not build the project nor write a build file"},
	{197, "Generate/compile all files in 'dir'"},
	{198, "Set the output filename"},
	{199, "euc.exe [options] file.ex...\n common options:"},
	{200, "\n translator options:"},
	{201, "Unknown platform: [1].  Supported platforms are: [2]"},
	{202, "Invalid maximum file size"},
	{203, "\nERROR: Must specify the file to be translated on the command line\n"},
	{204, "Warning [1]:\n\t[2]\n"},
	{205, "\nUnable to create warning file [1]"},
	{206, "\nPress Enter to continue, q to quit\n"},
	{207, "Defined Words"},
	{208, "\nPress Enter\n"},
	{209, "Can't create error message file: [1]\n"},
	{210, "<end-of-file>\n"},
	{211, "Internal Error:\n\t[1]\n"},
	{212, "Internal Error at [1]:[2]\n\t[3]\n"},
	{213, "Failed due to internal error."},
	{214, "Watcom cannot build translated files when there is a space in its parent folders"},
	{215, "Watcom needs to have an INCLUDE variable set to its included directories"},
	{216, "Watcom should have the H and the H\\NT includes at the front of the INCLUDE variable.  Watcom is located in [1].  The INCLUDE environment variable is [2]."},
	{217, "Statements have been inserted to trace execution of your program."},
	{218, "[1]:[2] - statement after [3] will never be executed"},
	{219, "[1]:[2] - call to [3]() might be short-circuited"},
	{220, "[1]:[2] - empty case block without fallthru"},
	{221, "[1]:[2] - no 'case else' supplied."},
	{222, "[1]:[2] - built-in routine [3]() overridden"},
	{223, "[1]:[2] - built-in routine [3]() overridden again"},
	{224, "can't mix profile and profile_time"},
	{225, "[1]:[2] - Unknown warning name [3]"},
	{226, "[1] - module variable '[2]' is never assigned a value"},
	{227, "[1] - private variable '[2]' of [3] is never assigned a value"},
	{228, "[1] - module constant '[2]' is not used"},
	{229, "[1] - module variable '[2]' is not used"},
	{230, "[1] - parameter '[2]' of [3]() is not used"},
	{231, "[1] - private variable '[2]' of [3]() is not used"},
	{232, "File '[1]' uses public symbols from '[2]', but does not include that file."},
	{233, "[1]:[2] - identifier '[3]' in '[4]' is not included"},
	{234, "The built-in [1]() in [2] overrides the global/public [1]() in:[3]"},
	{235, "[1]() needs at least [2] parameters, but some non-defaultable arguments are missing."},
	{236, "'[1]' needs [2] arguments"},
	{237, "'[1]' only needs [2] argument"},
	{238, "'[1]' only needs [2] arguments"},
	{239, "Translating code, pass: "},
	{240, " generating"},
	{241, "[1] "},
	{242, "-deleted-"},
	{243, "Couldn't open deleted.txt"},
	{244, "Deleted Symbols\n---------------\n\n"},
	{245, "The list of deleted symbols is in 'deleted.txt'"},
	{246, "You may now use [1] to run [2]"},
	{247, "You may now run [1]"},
	{248, "deleted [1] unused routines and [2] unused variables."},
	{249, "\nERROR: Must specify the file to be interpreted on the command line\n"},
	{250, "Bad BB_temp_type"},
	{251, "Bad BB_elem type"},
	{252, "Bad BB_elem"},
	{253, "Bad seq_elem"},
	{254, "This opcode ([1]) should never be emitted!  SubProg '[2]'"},
	{255, "no routine id for [1]"},
	{256, "Bad BB_var_type"},
	{257, "Bad GType"},
	{258, "or_type: t1 is [1], t2 is [2]\n"},
	{259, "unknown opcode: [1]"},
	{260, "Attempted to remove invalid forward reference"},
	{261, "Error resolving forward reference in case for '[1]'"},
	{262, "Bad operation.  Expected TYPE_CHECK ([1]) or TYPE_CHECK_FORWARD ([2]) , not [3]"},
	{263, "unrecognized forward reference type: [1] ([2])"},
	{264, "negative ref count for [1]"},
	{265, "Unhandled inline type: [1]"},
	{266, "error with token playback"},
	{267, "Set Private Scope - unhandled scope [1]"},
	{268, "Scanner unhandled class [1]"},
	{269, "Unknown op found when shifting code: [1]"},
	{270, "Euphoria Interpreter"},
	{271, "Euphoria to C Translator"},
	{272, "Euphoria Binder"},
	{273, "Using Managed Memory"},
	{274, "Using System Memory"},
	{275, "EuConsole"},
	{276, "-deleted-"},
	{277, "\nPaused: press any key ..."},
	{278, "\n(press any key and window will close ...)"},
	{279, "Turn on batch processing (do not \"Press Enter\" on error)"},
	{280, "Specify a configuration file"},
	{281, "Display all copyright notices"},
	{282, "Define a preprocessor word"},
	{283, "Add a directory to be searched for include files"},
	{284, "Defines a localization qualifier"},
	{285, "Defines the base name for localization databases"},
	{286, "Setup a pre-processor"},
	{287, "Force pre-processing regardless of cache state"},
	{288, "Enable all warnings"},
	{289, "Test syntax only, do not execute"},
	{290, "Display the version number"},
	{291, "Defines warning level"},
	{292, "Write all warnings to the given file instead of STDOUT"},
	{293, "Defines warning level by exclusion"},
	{294, "'[1]' is not supported in this platform"},
	{295, "IL code is not in proper format"},
	{296, "not an IL file!"},
	{297, "Obsolete .il file. Please recreate it using Euphoria 4.0 or later."},
	{298, "Internal error; seek to IL start failed!"},
	{299, "Can't open executable file '[1]'"},
	{300, "Internal error; Bound file may have been corrupted."},
	{301, "Couldn't open '[1]'!"},
	{302, "no Euphoria IL code to execute"},
	{303, "Does not create an executable. Just a .IL file for eub to run."},
	{304, "Does not display binding information"},
	{305, "List unused (deleted) symbols in 'deleted.txt'"},
	{306, "Prepares a file for use on Windows"},
	{307, "User supplied icon file used."},
	{308, "Windows Only: Uses the current console rather than creating a new console"},
	{309, "Includes symbol names in IL data"},
	{310, "The name of the executable to create. The default is the same basename of the input file."},
	{311, "An 'include' directory to use."},
	{312, "Display copyright information"},
	{313, "No file to bind was supplied."},
	{314, "Invalid option: [1]"},
	{315, "Internal error; Binding seek to start of IL failed!"},
	{316, "Internal error; Binding seek to checksum area failed!"},
	{317, "-deleted-"},
	{318, "Your custom icon file is too large."},
	{319, "Verbose output"},
	{320, "[1] - module variable '[2]' is assigned but never used"},
	{321, "[1] - parameter '[2]' of [3]() is assigned but never used"},
	{322, "[1] - private variable '[2]' of [3]() is assigned but never used"},
	{323, "Flags to pass to compiler (overrides internal compiler flags)"},
	{324, "Flags to pass to linker (overrides internal linker flags)"},
	{325, "Skipping  [1:3.0]% [2] (up-to-date)"},
	{326, "Force building, even if file is up-to-date"},
	{327, "[1] is deprecated"},
	{328, "Overrides the value of EUDIR"},
	{329, "Invalid character in HEX string"},
	{330, "Only enums may be declared as types"},
	{331, "Forward references are not supported for enums"},
	{332, "Indicate files or directories for which to gather coverage statistics"},
	{333, "Specify the filename for the coverage database."},
	{334, "Erase an existing coverage database and start a new coverage analysis."},
	{335, "Could not erase coverage database: [1]"},
	{336, "Could not create coverage table: [1]"},
	{337, "Could not create coverage database: [1]"},
	{338, "Exclude from coverage"},
	{339, "Error creating regex for coverage exclusion pattern '[1]'"},
	{340, "Expecting exactly two hexadecimal digits to follow the '\\x'"},
	{341, "Expecting exactly four hexadecimal digits to follow the '\\u'"},
	{342, "Expecting exactly eight hexadecimal digits to follow the '\\U'"},
	{343, "Expecting only '0', '1' or space to follow the '\\b'"},
	{344, "A numeric literal was expected"},
	{345, "Path to backend runner to use for binding" },
	{346, "Type check error:  assigning a sequence to an atom" },
	{347, "deleting [1]..." },
	{348, "User supplied library does not exist:\n    [1]"},
	{349, "Resource file does not exist:\n    [1]"},
	{350, "Unable to compile resource file: [1]"},
	{351, "Error in parsing scientific notation"},
	{352, "There is no watcom instalation under specified Watom Path [1]"},
	{NONSTANDARD_LIBRARY, "Use a non-standard library when building a shared object"},
	{354, "External debugger"},
	{355, "Use the -mno-cygwin flag with MinGW"},
	{356, "Specify the target architecture (X86, X86_64, ARM)"},
	{357, "Unknown architecture: [1].  Supported architectures are: [2]"},
	{ MSG_CC_PREFIX, "Prefix for compiler and related binaries"},
	{DUPLICATE_MULTI_ASSIGN, "duplicate variables in left hand side of multiple assignment"},
	{MISSING_CMD_PARAMETER, "Command line argument [1] requires a parameter"},
	{TRACE_LINES_CMD, "Specify the number of lines to use in ctrace.out"},
	{BAD_TRACE_LINES, "the -trace-lines option requires a valid number\n"},
	{BUILDDIR_IS_FILE, "Error: Specified build directory is a file"},
	{BUILDDIR_IS_UNDEFINED, "Error: Specified build directory is undefined (wildcards are not allowed)"},
	$
}

public function GetMsgText( integer MsgNum, integer WithNum = 1, object Args = {})
	integer idx = 1
	object msgtext

	-- First check localization databases
	msgtext = get_text( MsgNum, LocalizeQual, LocalDB )

	-- If not found, scan through hard-coded messages
	if atom(msgtext) then
		for i = 1 to length(StdErrMsgs) do
			if StdErrMsgs[i][1] = MsgNum then
				idx = i
				exit
			end if
		end for
		msgtext = StdErrMsgs[idx][2]
		if idx = 1 then
			Args = MsgNum
		end if
	end if

	if atom(Args) or length(Args) != 0 then
		msgtext = format(msgtext, Args)
	end if

	if WithNum != 0 then
		return sprintf("<%04d>:: %s", {MsgNum, msgtext})
	else
		return msgtext
	end if
end function

public procedure ShowMsg(integer Cons, object Msg, object Args = {}, integer NL = 1)

	if atom(Msg) then
		Msg = GetMsgText(floor(Msg), 0)
	end if

	if atom(Args) or length(Args) != 0 then
		Msg = format(Msg, Args)
	end if

	puts(Cons, Msg)

	if NL then
		puts(Cons, '\n')
	end if

end procedure
