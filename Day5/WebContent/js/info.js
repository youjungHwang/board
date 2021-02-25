function sendit(){
	// 아이디 관련된거 전부 삭제 
	
    // 정규식 -> RegExp 사용해보자   
    const pwCheck = RegExp(/^[a-zA-Z0-9]{6,20}$/);
    const nameCheck = RegExp(/^[가-힣]+$/);
    const hpCheck = RegExp(/^\d{3}-\d{3,4}-\d{4}$/);
    const emailCheck = RegExp(/^[a-zA-Z0-9\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-]+/);
    
    // 비밀번호 맞게 넣었는지 확인용
    if(!pwCheck.test($('#userpw').val())){
        alert('비밀번호를 형식에 맞게 입력하세요.');
        $('#userpw').val('');
        $('#userpw').focus();
        return false;
    }
    if($('#userpw').val() != $('#userpw_re').val()){
        alert('비밀번호가 서로 다릅니다.');
        $('#userpw').val('');
        $('#userpw_re').val('');
        $('#userpw').focus();
        return false;
    }
    if(!nameCheck.test($('#username').val())){
        alert('이름은 한글로 입력하세요.');
        $('#username').val('');
        $('#username').focus();
        return false;
    }
    if(!hpCheck.test($('#hp').val())){
        alert('휴대폰번호를 형식에 맞게 입력하세요.(-포함)');
        $('#hp').val('');
        $('#hp').focus();
        return false;
    }
    if(!emailCheck.test($('#email').val())){
        alert('이메일을 형식에 맞게 입력하세요.');
        $('#email').val('');
        $('#email').focus();
        return false;
    }

    let hobbyCheck = false;

    for(let i=0; i<$("[name='hobby']").length; i++){
        if($("input:checkbox[name='hobby']").eq(i).is(":checked") == true){
            hobbyCheck = true;
            break;
        }
    }
    if(!hobbyCheck){  // false면
        alert('취미는 한개이상 체크하세요');
        return false;
    }
    
    if($('#ssn1').val() == "" || $('#ssn2').val() == ""){
        alert('주민등록번호를 입력하세요');
        $('#ssn1').focus();
        return false;
    }
    if($('#isSsn').val() == 'n'){
        alert('주민등록번호 유효성 체크를 눌러주세요');
        return false;
    }

    return true;  


}



$(function(){
	// 주민등록번호 검증
    $('#ssn1').on('keyup', function(){
        if($(this).val().length >= 6){
            $('#ssn2').focus();
        }
    });
    $('#ssn1, #ssn2').on('keydown', function(){
        $('#isSsn').val('n'); // 검증y 받고 숫자 수정시 다시 n (검증을 다시 받아야함)
    });
    $("#ssnBtn").on('click', function(){
        let ssn = $('#ssn1').val() + $('#ssn2').val();
        let fmt = RegExp(/^\d{6}[12345]\d{6}/);  // 7번째 자리에는 1,2,3,4,5가 들어가야한다(or로 연결)
        let arr = new Array(13);
        if(!fmt.test(ssn)){
            alert('주민등록번호 형식에 맞게 입력하세요');
            $('#ssn1').val(''); 
            $('#ssn2').val('');
            $('#ssn1').focus();
            return false;
        }
        for(let i=0; i<arr.length; i++){
            arr[i] = parseInt(ssn.charAt(i))
        }
        const mul = [2,3,4,5,6,7,8,9,2,3,4,5];  // 곱해줄 것 배열로 넣어둠
        let sum = 0;
        for(let i=0; i<arr.length-1; i++){  // i<arr.length-1 ★
            sum += (arr[i] *= mul[i])
        }
        if((11 - (sum % 11)) % 10 != arr[12]){ // 10보다 작아도(9) 나머지는 같아서(9) 한꺼번에 적어도 괜찮음
            alert('유효하지 않은 주민등록번호입니다.');
            $('#ssn1').val(''); 
            $('#ssn2').val('');
            $('#ssn1').focus();
            return false;
        }
        alert('검증되었습니다.');
        $('#isSsn').val('y');
    });
});