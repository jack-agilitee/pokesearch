## Complete Todo Task

**Command:** Complete a todo task from a markdown file

**Process:**
1. Prompt user for the local path to a todo markdown file
2. Read and analyze the todo file contents
3. Check git status to ensure working directory is clean
4. Create feature branch for the todo implementation
5. Execute all tasks defined in the todo file
6. Follow project best practices from CLAUDE.md
7. Run tests and linting after implementation
8. Commit changes with descriptive message
9. Push branch and create pull request
10. Mark todo as completed

**Implementation Steps:**
```bash
# 1. FIRST: Prompt user for the todo file path
# Ask: "Which todo file would you like to complete? Please provide the path:"
# Wait for user response before proceeding

# 2. Read and validate todo file
# Ensure file exists and contains valid todo structure

# 3. Check git status - ensure clean working directory
git status

# If uncommitted changes exist:
# "Please commit or stash your changes before starting a new todo"

# 4. Extract todo name from filename for branch naming
# Example: 01-setup-capacitor-camera.md -> setup-capacitor-camera

# 5. Create and checkout feature branch
git checkout -b feature/todo-${todo-name}

# 6. Parse todo file and extract:
# - Objective
# - Prerequisites (verify these are met)
# - Tasks to complete
# - Success criteria
# - Files to create/modify

# 7. Execute each task following best practices:
# For Ionic/React (pokestart folder):
# - Use functional components with TypeScript
# - Follow interface patterns from CLAUDE.md
# - Use Ionic UI components
# - Component-specific CSS files
# - Add tests with .test.tsx extension

# For Backend (if creating backend):
# - Use TypeScript with Express
# - Follow middleware patterns
# - Add proper error handling
# - Include validation
# - Add tests

# 8. Navigate to appropriate project directory
cd pokestart  # or pokesearch-backend if backend task

# 9. Install any required dependencies
npm install [packages from todo]

# 10. Create/modify files as specified in todo
# Follow patterns from CLAUDE.md:
# - TypeScript interfaces for props
# - React.FC for functional components
# - Ionic components for UI
# - Proper file naming conventions

# 11. Run tests and linting
npm run test.unit
npm run lint

# Fix any issues found

# 12. Test implementation manually
# - For frontend: npm run dev and test in browser
# - For backend: npm run dev and test endpoints
# - Verify all success criteria are met

# 13. Mark todo as completed in the original file
# Update checkbox from [ ] to [x] for completed items
# This ensures the todo is marked complete before committing

# 14. Stage and commit changes (including the updated todo file)
git add .
git commit -m "feat: complete ${todo-name} todo

- ${list of completed tasks from todo}
- All tests passing
- Success criteria met
- Todo marked as completed

Todo: ${todo-file-path}"

# 15. Push branch
git push -u origin feature/todo-${todo-name}

# 16. Create pull request
gh pr create --title "feat: Complete ${todo-name} todo" --body "## Description
Completed todo task from ${todo-file-path}

## Changes Made
${list specific changes and files created/modified}

## Testing
- [ ] Unit tests pass
- [ ] Linting passes
- [ ] Manual testing completed
- [ ] Success criteria verified

## Success Criteria Met
${list success criteria from todo and confirm each}

## Files Changed
${list all files created or modified}

## Next Steps
${mention next todo in sequence if applicable}"

# 17. Checkout back to main branch
git checkout main
echo "✅ Todo completed successfully! Switched back to main branch."
```

**Validation Checks:**
- Ensure todo file exists and is readable
- Verify prerequisites are met before starting
- Check that working directory is clean
- Validate all required dependencies are available
- Ensure tests pass before committing
- Verify all success criteria are met

**Best Practices from CLAUDE.md:**
- Use functional components with TypeScript interfaces
- Follow Ionic component patterns
- Strict TypeScript mode compliance
- Component-specific CSS files
- Tests next to components (.test.tsx)
- PascalCase for components, camelCase for utilities
- Use ESNext features
- Follow existing project patterns

**Error Handling:**
- If todo file not found: "Todo file not found at specified path"
- If prerequisites not met: "Prerequisites not satisfied: [list missing items]"
- If tests fail: "Tests failing - please fix before committing"
- If git working directory not clean: "Uncommitted changes detected - please commit or stash"

**Example Usage:**
```
User: /complete-todo
Assistant: Which todo file would you like to complete? Please provide the path:
User: todos/phase-1/01-setup-capacitor-camera.md
Assistant: [Proceeds to complete the todo task]
