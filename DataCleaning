-- Standardise Date Format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM HousingData-- Standardise Date Format

-- Populate Property Address
SELECT *
FROM HousingData 
WHERE PropertyAddress IS NULL

-- ParcelID is the unique code for an address, therefore we can find the missing address from the ParcelID
SELECT HousingData1.ParcelID, HousingData1.PropertyAddress, HousingData2.ParcelID, HousingData2.PropertyAddress, ISNULL(HousingData1.PropertyAddress,HousingData2.PropertyAddress)
FROM HousingData AS HousingData1
JOIN HousingData AS HousingData2
ON HousingData1.ParcelID = HousingData1.ParcelID AND HousingData1.UniqueID != HousingData1.ParcelID -- returns only rows that have different Uniqueid
WHERE PropertyAddress IS NULL

-- Now update the original table
UPDATE HousingData1
SET ISNULL(HousingData1.PropertyAddress,HousingData2.PropertyAddress)
SELECT * HousingData1.PacerlID, HousingData1.PropertyAddress, HousingData2.PacerlID, HousingData2.PropertyAddress, ISNULL(HousingData1.PropertyAddress,HousingData2.PropertyAddress)
FROM HousingData AS HousingData1
JOIN HousingData AS HousingData2
ON HousingData1.ParcelID = HousingData1.ParcelID AND HousingData1.UniqueID != HousingData1.ParcelID -- returns only rows that have different Uniqueid
WHERE PropertyAddress IS NULL

-- Breaking down property address into columns with SUBSTRING:  Address and City
SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress -1)) AS Adress -- without '-1' the substring would return a coma, which is the delimiter
SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress +1 LEN(PropertyAddress) as City
FROM HousingData

-- Add SplitPropertyAddress column
ALTER TABLE HousingData
ADD SplitPropertyAddress VARCHAR(250)

UPDATE HousingData
SET SplitPropertyAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress -1))

-- Add SplitPropertyCity column
ALTER TABLE HousingData
ADD SplitPropertyCity VARCHAR(250)

UPDATE HousingData
SET SplitPropertyCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress +1 LEN(PropertyAddress) 

-- Breaking down owner address into columns with PARSENAME:  Address and City
SELECT PARSENAME (REPLACE(OwnerAddress,',','.'),1) -- it returns the last position in the columns, to put it in order, start with the last positon (in this case would be 3)
SELECT PARSENAME (REPLACE(OwnerAddress,',','.'),2)
SELECT PARSENAME (REPLACE(OwnerAddress,',','.'),3)
FROM HousingData

-- Add OwnerSplitAddress column
ALTER TABLE HousingData
ADD OwnerSplitAddress VARCHAR(250)

UPDATE HousingData
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'),3)

-- Add OwnerSplitCity column
ALTER TABLE HousingData
ADD OwnerSplitCity VARCHAR(250)

UPDATE HousingData
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress,',','.'),2)

-- Add OwnerSplitState column
ALTER TABLE HousingData
ADD OwnerSplitState VARCHAR(250)

UPDATE HousingData
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress,',','.'),1)

-- Remove PropertyAddress and OwnerAddress 
ALTER TABLE HousingData
DROP COLUMN PropertyAddress, OwnerAddress


-- Change N and Y to Yes and No in SoldAsVacant column
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END 
FROM HousingData

UPDATE HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant

-- Spot duplicate rows and create a CTE
WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) row_num
FROM HousingData)

SELECT * 
FROM RowNumCTE
WHERE row_num >1

-- Now delete duplicates
DELETE -- replaced SELECT * from above
FROM RowNumCTE
WHERE row_num >1
