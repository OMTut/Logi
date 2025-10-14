# 🧪 Logi Silent Update Testing

This directory contains tools for testing the new silent update functionality locally without affecting production users.

## 📋 **Quick Test Setup**

### **Step 1: Start Test Server**
```bash
# From tests/update_test directory
python test_server.py
# OR
start_test_server.bat
```

### **Step 2: Configure Logi for Testing**
In your running Logi app, you'll need to temporarily point it to the test server.

**Option A: Modify UpdateChecker temporarily**
- Change `VERSION_CHECK_URL` in `UpdateChecker.cpp` to `"http://localhost:8080/version.json"`
- Rebuild and run

**Option B: Use test method (if available)**
- Call `updateChecker.setVersionCheckUrl("http://localhost:8080/version.json")` from QML or tests

### **Step 3: Test the Update Flow**
1. ✅ Run your modified Logi app
2. ✅ Check that update banner appears (should show version 1.0.2)
3. ✅ Click "Update Now" button
4. ✅ Verify progress dialog appears
5. ✅ Watch download progress bar
6. ✅ Confirm status changes to "Installing..."
7. ✅ App should exit and installer should run
8. ✅ Verify app restarts automatically

## 🛠 **Test Scenarios**

### **Scenario 1: Normal Update Flow**
- Version: 1.0.2 (higher than current)
- Update Required: false
- Expected: Optional update banner, smooth installation

### **Scenario 2: Required Update** 
Edit `test_version.json`:
```json
{
  "update_required": true
}
```
- Expected: Red banner, app locks until update

### **Scenario 3: Network Error**
- Stop test server while download is in progress
- Expected: Error message in progress dialog

### **Scenario 4: Invalid Installer**
- Replace LogiSetup.exe with a dummy file
- Expected: Installation should fail gracefully

## 📁 **Files Created**

- `test_version.json` - Test version metadata
- `test_server.py` - Local HTTP server
- `start_test_server.bat` - Convenience script
- `README.md` - This guide

## 🔧 **Customizing Tests**

Edit `test_version.json` to test different scenarios:

```json
{
  "version": "1.1.0",           // Change version number
  "update_required": true,       // Test required updates
  "file_size": 50000000,        // Test different file sizes
  "changelog": ["Test item"]     // Modify changelog
}
```

## 🚨 **Safety Notes**

- ⚠️ The test server serves your actual installer
- ⚠️ Testing will actually install/update your app
- ⚠️ Make backups before testing
- ⚠️ Don't commit changes to VERSION_CHECK_URL

## 🐛 **Troubleshooting**

**Port 8080 in use:**
```python
# Change PORT in test_server.py
PORT = 8081  # or any available port
```

**Python not found:**
```bash
# Make sure Python 3 is installed and in PATH
python --version
```

**Installer not found:**
```bash
# Build the installer first
cd ../../installer
build_installer_inno.bat
```

## 🧹 **Cleanup After Testing**

1. Stop test server (Ctrl+C)
2. Revert any changes to UpdateChecker.cpp
3. Rebuild app with original URL
4. Delete test files if no longer needed

## 💡 **Advanced Testing**

For more sophisticated testing, you can:

1. **Test with Different Network Conditions**
   - Add delays in test_server.py
   - Simulate network failures

2. **Test Installer Variations**
   - Create test installers with different versions
   - Test with corrupted installers

3. **Test Concurrent Updates**
   - Run multiple instances
   - Test update conflicts