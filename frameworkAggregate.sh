# Sets the target folders and the final framework product.

# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME

# 例如: FMK_NAME = "MyFramework"

FMK_NAME=FMLiveSDK

if [ "${ACTION}" = "build" ]

then

# 设置Configuration，为Debug和Release

COF_NAME_DEBUG=Debug

COF_NAME_RELEASE=Release

# Install dir will be the final output to the framework.

# The following line create it in the root folder of the current project.

# 最后生成Debug和Release版本的framework的路径

INSTALL_DIR_DEBUG=${SRCROOT}/Products/${COF_NAME_DEBUG}/${FMK_NAME}.framework

INSTALL_DIR_RELEASE=${SRCROOT}/Products/${COF_NAME_RELEASE}/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.

# 编译之后的framework路径

WRK_DIR=build

DEVICE_DIR_DEBUG=${WRK_DIR}/${COF_NAME_DEBUG}-iphoneos/${FMK_NAME}.framework

SIMULATOR_DIR_DEBUG=${WRK_DIR}/${COF_NAME_DEBUG}-iphonesimulator/${FMK_NAME}.framework

DEVICE_DIR_RELEASE=${WRK_DIR}/${COF_NAME_RELEASE}-iphoneos/${FMK_NAME}.framework

SIMULATOR_DIR_RELEASE=${WRK_DIR}/${COF_NAME_RELEASE}-iphonesimulator/${FMK_NAME}.framework

# -configuration ${CONFIGURATION}

# Clean and Building both architectures.

# 编译各个版本的framework

xcodebuild -configuration ${COF_NAME_DEBUG} -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphoneos clean build

xcodebuild -configuration ${COF_NAME_DEBUG} -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator clean build

xcodebuild -configuration ${COF_NAME_RELEASE} -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphoneos clean build

xcodebuild -configuration ${COF_NAME_RELEASE} -target "${FMK_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator clean build

# Cleaning the oldest.

if [ -d "${INSTALL_DIR_DEBUG}" ]

then

rm -rf "${INSTALL_DIR_DEBUG}"

fi

mkdir -p "${INSTALL_DIR_DEBUG}"

cp -R "${DEVICE_DIR_DEBUG}/" "${INSTALL_DIR_DEBUG}/"

# 合并Debug版本的framework

lipo -create "${DEVICE_DIR_DEBUG}/${FMK_NAME}" "${SIMULATOR_DIR_DEBUG}/${FMK_NAME}" -output "${INSTALL_DIR_DEBUG}/${FMK_NAME}"

# Cleaning the oldest.

if [ -d "${INSTALL_DIR_RELEASE}" ]

then

rm -rf "${INSTALL_DIR_RELEASE}"

fi

mkdir -p "${INSTALL_DIR_RELEASE}"

cp -R "${DEVICE_DIR_RELEASE}/" "${INSTALL_DIR_RELEASE}/"

# 合并Release版本的framework

lipo -create "${DEVICE_DIR_RELEASE}/${FMK_NAME}" "${SIMULATOR_DIR_RELEASE}/${FMK_NAME}" -output "${INSTALL_DIR_RELEASE}/${FMK_NAME}"

# 删除build路径

rm -r "${WRK_DIR}"

open "${INSTALL_DIR_RELEASE}"

fi
