# Running Tests

## Build and Run Tests

```bash
# Configure with testing enabled
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug

# Build the tests
cmake --build build --config Debug

# Run all tests
ctest --test-dir build -C Debug

# Run specific test executable directly
./build/tests/Debug/LogiTests.exe

# Run with verbose output
ctest --test-dir build -C Debug --verbose

# Run specific test case
./build/tests/Debug/LogiTests.exe testRequiredUpdateAvailable
```

## Test Structure

### UpdateChecker Tests (`tst_updatechecker.cpp`)

**Version Comparison Tests:**
- `testVersionComparison()` - Data-driven tests for version comparison logic
- Tests various scenarios: same version, newer available, major updates, etc.

**Update Checking Tests:**
- `testOptionalUpdateAvailable()` - Tests optional update detection
- `testRequiredUpdateAvailable()` - Tests required update detection  
- `testMalformedResponse()` - Tests handling of invalid JSON
- `testNetworkError()` - Tests network failure scenarios

**Property & Signal Tests:**
- `testUpdateAvailableProperty()` - Tests property change notifications
- `testVersionProperties()` - Tests all version info properties
- `testMultipleSimultaneousChecks()` - Tests concurrent request handling

### Mock Server (`MockUpdateServer`)

The test suite uses a local HTTP server to simulate the remote version.json endpoint:

- **Configurable responses** - Set custom JSON responses for different test scenarios
- **Error simulation** - Generate network errors, HTTP status codes
- **Response delays** - Test timeout handling
- **Multiple test data files** - Use different version.json files per test

### Test Data Files

- `test_version_required.json` - Required update scenario
- `test_version_normal.json` - Optional update scenario  
- `test_version_malformed.json` - Invalid JSON for error testing

## Writing Additional Tests

### Testing Other Components

```cpp
// Example: Testing Settings class
class TestSettings : public QObject
{
    Q_OBJECT
private slots:
    void testSettingsPersistence();
    void testDirectoryValidation();
};

// Example: Testing LogReader class
class TestLogReader : public QObject  
{
    Q_OBJECT
private slots:
    void testLogFileParsing();
    void testDeathEventDetection();
};
```

### QML Component Testing

```cpp
// Use Qt Quick Test for QML components
#include <QtQuickTest/quicktest.h>
QUICK_TEST_MAIN(qml_tests)

// Test QML files in tests/qml/
// tests/qml/tst_UpdateBanner.qml
import QtTest 1.0
import QtQuick 2.0

TestCase {
    name: "UpdateBanner"
    
    function test_requiredUpdateStyling() {
        // Test QML component behavior
    }
}
```

## Continuous Integration

Add this to your CI pipeline:

```yaml
# GitHub Actions example
- name: Run Tests
  run: |
    cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug
    cmake --build build --config Debug
    ctest --test-dir build -C Debug --output-on-failure
```