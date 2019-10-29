/**�ϴ�ͼƬ**/
    public void uploadImages(){
        List<Map<String,Object>> upload=uploadFiles(getRequest(), PropKit.get("upload_path"), 10, "", "gif,jpg,jpeg,png,bmp");
        renderJson(JsonKit.toJson(upload.get(0)));
    }
����private static FileRenamePolicy fileRenamePolicy = new DefaultFileRenamePolicy();
    /**
     * 
     * @param request �ļ��ϴ�����
     * @param uploadPath �ļ��ϴ�·��
     * @param maxPostSize �ļ���������С��MB��
     * @param encoding �ַ����뼯���ã�Ĭ��utf-8��
     * @param filetype �ϴ��ļ���ʽ����չ������չ������","��������չ��ǰû��"."��
     * @return �ϴ����ļ������ļ�·��
     */
    public static List<Map<String,Object>> uploadFiles(HttpServletRequest request,String uploadPath,int maxPostSize,String encoding,String filetype){
        
        encoding=encoding==null||"".equals(encoding)?"utf-8":encoding;
        
        File dir = new File(uploadPath);
        if ( !dir.exists()) {
            if (!dir.mkdirs()) {
                throw new IllegalArgumentException("�ļ�·���޷�����");
            }
        }
        
        List<Map<String,Object>> uploadFileDatas=new ArrayList<Map<String,Object>>();
        
        try {
            MultipartRequest multipartRequest = new  MultipartRequest(request, uploadPath, maxPostSize*1024*1024, encoding, fileRenamePolicy);
            Enumeration<?> files = multipartRequest.getFileNames();
            while (files.hasMoreElements()) {
                String name = (String)files.nextElement();
                String filesystemName = multipartRequest.getFilesystemName(name);
                // У���ļ���ʽ
                if (filesystemName != null) {
                    Map<String, Object> ulfd=new HashMap<String,Object>();
                    if(checkFileType(filesystemName.substring(filesystemName.lastIndexOf(".")+1),filetype)){
                        ulfd.put("parameterName", name);
                        ulfd.put("uploadPath", uploadPath+System.getProperty("file.separator")+filesystemName);//ͼƬ������·��
                        ulfd.put("url", filesystemName);
                        ulfd.put("originalFileName", multipartRequest.getOriginalFileName(name));
                        ulfd.put("contentType", multipartRequest.getContentType(name));
                        ulfd.put("state", "SUCCESS");
                    }else{
                        new File(uploadPath+"/"+filesystemName).delete();
                        ulfd.put("state", "�ļ���ʽ�Ƿ�");
                    }
                    uploadFileDatas.add(ulfd);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return uploadFileDatas;
    }
    
    private static boolean checkFileType(String extension,String filetype){
        filetype=(filetype==null?"":filetype);
        String[] types=filetype.split(",");
        for(int i=0;i<types.length;i++){
            if(!extension.trim().toLowerCase().equals(types[i].trim().toLowerCase())){
                break;
            }else if(i==types.length-1){
                return false;
            }
        }
        return true;
    }